Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29B64D21E
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfFTP07 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 11:26:59 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37361 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFTP07 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 11:26:59 -0400
Received: by mail-yw1-f65.google.com with SMTP id 186so1345898ywo.4
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 08:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mXcugnzpL7dOnp6Vw2UQR4tCTvhD/TR6Ab35dySy920=;
        b=ADU4b7JfBkzE88XkZN/EoJ1hn35ozaFX6txDj2QpoPnS+9MALejkr+PR3eviuLkt9i
         Urqf5I1Jv6Iuae5yENB9M10bX3HRcW7wLD81bVDwS+U/DG9hIdqKvv0kYAaZRcNtm/Ix
         hxknx3/ZglPYN9bK46sKZ/H8YJ8BDyrXTRPH1B9ttoIQnf6EjKnEEyByNX/KGpTQMnsC
         R6j6eSUcR55rnodUJVMeOAmdUIe3DM4ncTIE3eERJKwz9LUFVAUKih+r1nPLzQuXeGCM
         xe09KKi469/3NbQhWHkApktqCiLpJI41nsjzglkVU9C/QMY2Jl/Iu/NxKtQc74gaLMDO
         UspQ==
X-Gm-Message-State: APjAAAViZjeR13qP4iIfvvJ5hwBDbxp+FGZqqVuSfNlQHLOV/xC4qZn1
        zjZeEtrxTFHfJMJ3VF3IIXBqlA==
X-Google-Smtp-Source: APXvYqzldB9p3ZYmw2reyfkyt/XNTo76jTQbP7GpGI8co40PAc19RTlpijGR4ucWzlHkjb81kJkulA==
X-Received: by 2002:a81:a041:: with SMTP id x62mr5834132ywg.378.1561044418418;
        Thu, 20 Jun 2019 08:26:58 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-5C3.dyn6.twc.com. [2606:a000:1100:37d::5c3])
        by smtp.gmail.com with ESMTPSA id 15sm3432423ywo.74.2019.06.20.08.26.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:26:57 -0700 (PDT)
Message-ID: <26f234655373ab32bf118cb6550fc04c0624a3d7.camel@redhat.com>
Subject: Re: [PATCH 7/8] ceph: check page writeback error during write
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Thu, 20 Jun 2019 11:26:56 -0400
In-Reply-To: <20190617125529.6230-8-zyan@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-8-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> Make write(2) return error prematurely if there is writeback error.
> User can use fsync() or fdatasync() to clear the error.
> 
> This change is mainly for reporting errors after blacklist + reconnect.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 57e1447a9d4b..f07767d3864c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2814,6 +2814,14 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  		break;
>  	}
>  
> +	if (_got & CEPH_CAP_FILE_WR) {
> +		ret = filemap_check_wb_err(inode->i_mapping, filp->f_wb_err);
> +		if (ret < 0) {
> +			ceph_put_cap_refs(ci, _got);
> +			return ret;
> +		}
> +	}
> +
>  	if ((_got & CEPH_CAP_FILE_RD) && (_got & CEPH_CAP_FILE_CACHE))
>  		ceph_fscache_revalidate_cookie(ci);
>  

This seems wrong. Just because an earlier write failed, we don't
necessarily want to start returning errors on other writes. I'd drop
this patch.

-- 
Jeff Layton <jlayton@redhat.com>

