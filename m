Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A277B46E8AB
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 13:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhLIM7x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 07:59:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235554AbhLIM7w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 07:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639054578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRkQjn/lX4ODhdG6/e8hU5EbF5uXu7Cb4Y7yrGmi6Js=;
        b=Betp7OZjWT8WQQl/gmHeufrEPtkF3Qg2txm0BQCAkn0M4odxRhgpN9+YB/+U8La7CJgxTd
        inUuCEw599jDgmtlJe6nRXLmDn8Kza+9GNMfUYAi8WvmNPYt0nDQXJAkO9IvU/uvMG6/7t
        X8TSdYt17RYh0iHvvAdmf2FIy2t6z7w=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-b_WpfVcjOROW0CxgezSqEA-1; Thu, 09 Dec 2021 07:56:15 -0500
X-MC-Unique: b_WpfVcjOROW0CxgezSqEA-1
Received: by mail-pj1-f69.google.com with SMTP id iq9-20020a17090afb4900b001a54412feb0so3742270pjb.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 04:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HRkQjn/lX4ODhdG6/e8hU5EbF5uXu7Cb4Y7yrGmi6Js=;
        b=q9a/XMQXwqeoWMeBsIUigdUk3rg2xIwkpq8zPIm+a6Rf2mck4H06OA9ada20Ijm9gf
         HbdCxfJSRxQl8ye1wkf58FEW0gEUESovdM96avNYGIWq0iELeBO5azz6LCQJS6Lmilpi
         qI9ccHdcq8CHZHRy2OPmn+m9Qbi87OBMclgt575C+omxUjtubFqRRgp9TOaHoBKrtEJ+
         rn5dgRuaPtqhN+BP1Wx9zz+rLxVMODiMHLxE3cQ5CGKSNjJg83YkCoyV79mqhDJNii6p
         cTnh+zE3D9a+KBfcNufH8Sqkfp/T50Hud6CxwLXsoABGwY7g/yMN3blAzOqz5yfooG2f
         uIXg==
X-Gm-Message-State: AOAM533o7QnC2YqKi/M0igZY313izSDheVpwxNA6IFMS4YHPbtPca0dW
        3TTJSR5Zoa2lJEkOMjRUKTArvnKZpgSydxBt2E6HQ/E24BdCmAThY6oO/+gFFpMchEijdLnLJ8w
        VScCPLk1eQMYUxskLmHOogw==
X-Received: by 2002:a17:90a:df88:: with SMTP id p8mr15506278pjv.32.1639054574206;
        Thu, 09 Dec 2021 04:56:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6CATcR1JktwXCTqX7DJHyvlSEnLpOZapsh4F9x7C94Y0X+w3X4hSuCHJ/CDWgvA7tBjycVg==
X-Received: by 2002:a17:90a:df88:: with SMTP id p8mr15506246pjv.32.1639054573957;
        Thu, 09 Dec 2021 04:56:13 -0800 (PST)
Received: from [10.72.12.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v15sm7857444pfu.195.2021.12.09.04.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 04:56:13 -0800 (PST)
Subject: Re: [PATCH v2] ceph: don't check for quotas on MDS stray dirs
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <20211207152705.167010-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <89108f49-e647-2d23-5d34-b4fddc283e22@redhat.com>
Date:   Thu, 9 Dec 2021 20:56:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211207152705.167010-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/7/21 11:27 PM, Jeff Layton wrote:
> 玮文 胡 reported seeing the WARN_RATELIMIT pop when writing to an
> inode that had been transplanted into the stray dir. The client was
> trying to look up the quotarealm info from the parent and that tripped
> the warning.
>
> Change the ceph_vino_is_reserved helper to not throw a warning for
> MDS stray directories (0x100 - 0x1ff), only for reserved dirs that
> are not in that range.
>
> Also, fix ceph_has_realms_with_quotas to return false when encountering
> a reserved inode.
>
> URL: https://tracker.ceph.com/issues/53180
> Reported-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Reviewed-by: Luis Henriques <lhenriques@suse.de>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/quota.c |  3 +++
>   fs/ceph/super.h | 20 ++++++++++++--------
>   2 files changed, 15 insertions(+), 8 deletions(-)
>
> I was still seeing some warnings even with the earlier patch, so I
> decided to rework it to just never warn on MDS stray dirs. This should
> also silence the warnings on MDS stray dirs (and also alleviate Luis'
> concern about the function renaming in the earlier patch).
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 24ae13ea2241..a338a3ec0dc4 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
>   	/* if root is the real CephFS root, we don't have quota realms */
>   	if (root && ceph_ino(root) == CEPH_INO_ROOT)
>   		return false;
> +	/* MDS stray dirs have no quota realms */
> +	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
> +		return false;
>   	/* otherwise, we can't know for sure */
>   	return true;
>   }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 387ee33894db..f9b1bbf26c1b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -541,19 +541,23 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>    *
>    * These come from src/mds/mdstypes.h in the ceph sources.
>    */
> -#define CEPH_MAX_MDS		0x100
> -#define CEPH_NUM_STRAY		10
> +#define CEPH_MAX_MDS			0x100
> +#define CEPH_NUM_STRAY			10
>   #define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
> +#define CEPH_MDS_INO_LOG_OFFSET		(2 * CEPH_MAX_MDS)
>   #define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
>   
>   static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>   {
> -	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> -	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> -		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> -		return true;
> -	}
> -	return false;
> +	if (vino.ino >= CEPH_INO_SYSTEM_BASE ||
> +	    vino.ino < CEPH_MDS_INO_MDSDIR_OFFSET)
> +		return false;
> +
> +	/* Don't warn on mdsdirs */
> +	WARN_RATELIMIT(vino.ino >= CEPH_MDS_INO_LOG_OFFSET,
> +			"Attempt to access reserved inode number 0x%llx",
> +			vino.ino);
> +	return true;
>   }
>   
>   static inline struct inode *ceph_find_inode(struct super_block *sb,

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


