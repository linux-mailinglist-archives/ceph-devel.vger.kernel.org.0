Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E523C8887
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 18:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhGNQU3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 12:20:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhGNQU2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 12:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626279456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/lZvkzlvEnFL1hF2GkEQUeuPg921MsAI71X1MDyxViA=;
        b=QR1JNC+Hqr3FFnMdS7y1UwcLQc51+GsTFPWs1F3L+SO8//0NCEK29PXuwanTX7dexRsNab
        sxD9KkdZlOt2UOuSmkl/vg3DEpQD44gXC/wrYbBF+xxtoCB6SQ/z8XWZSdbk8iinsNPWa3
        fcxgTv3Q1VtELG/zm4Sj9y5lA4kOnCs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-1Rkp-k4vMBSiEbf-aKlzfA-1; Wed, 14 Jul 2021 12:17:35 -0400
X-MC-Unique: 1Rkp-k4vMBSiEbf-aKlzfA-1
Received: by mail-qk1-f199.google.com with SMTP id f203-20020a379cd40000b02903b861bec838so1588309qke.7
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 09:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/lZvkzlvEnFL1hF2GkEQUeuPg921MsAI71X1MDyxViA=;
        b=hvz8S6lukIYCIiA2B2AukJdNIeqrLkGrkTr5XG3J3jywmZ2+eQf1zpe61mwJbMOIGr
         710kY9XgumXsG5VRybWZzZkDMIYSTknWeaE1C+wbkk3Kgrrja2KEboD3nfdtg/v6E9jF
         G6IMCvrD7nU5scMYpEMGcRee/9mIw/jXylDSbjONqUUNLRX6YwGvXPu8PNUx+jiNHFbG
         /x33xQFs6XrnhU8uMVU3EV8C2Zgg/pXz57Z2/0IiojixUW9Xpw3UFDEt308zM1YLxHnw
         JG7nk2n6VlociO7VgzgNBJ23YN3v6KJbRvDoV/w072Nhsy3GvNkHuNGMnLaP95iYbM4U
         v9Ew==
X-Gm-Message-State: AOAM5321mSsg7lhYLgjq7msKtb1QP/t+AmhTxwvRlRpOKZ3YMJ/desaM
        6qeMwGXAq6oKooQqMhq8EEYHtAmSW3YJYhXYIrEy6NPxcV8D4Q2ofu/Asljd08bePSb5l10ahrl
        TVdek+79r+nIw8hhOXnOsvA==
X-Received: by 2002:ac8:5d47:: with SMTP id g7mr9793676qtx.351.1626279454731;
        Wed, 14 Jul 2021 09:17:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmaGOWnR5fQ0rYrSeMdBGsI0XsMwXgL4qZvYa6WQ2AXBku4gSi17DZ1B//aAKnFJYfUpd9ow==
X-Received: by 2002:ac8:5d47:: with SMTP id g7mr9793663qtx.351.1626279454552;
        Wed, 14 Jul 2021 09:17:34 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id b3sm936430qto.49.2021.07.14.09.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 09:17:34 -0700 (PDT)
Message-ID: <848d919c6a791ab9b7c61d7cb89f759b55195c18.camel@redhat.com>
Subject: Re: [PATCH v4 4/5] ceph: record updated mon_addr on remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 14 Jul 2021 12:17:33 -0400
In-Reply-To: <20210714100554.85978-5-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
         <20210714100554.85978-5-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> Note that the new monitors are just shown in /proc/mounts.
> Ceph does not (re)connect to new monitors yet.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d8c6168b7fcd..d3a5a3729c5b 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
>  	else
>  		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
>  
> +	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
> +		kfree(fsc->mount_options->mon_addr);
> +		fsc->mount_options->mon_addr = fsopt->mon_addr;
> +		fsopt->mon_addr = NULL;
> +		printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");

It's currently more in-vogue to use pr_notice() for this. I'll plan to
make that (minor) change before I merge. No need to resend.

> +	}
> +
>  	sync_filesystem(fc->root->d_sb);
>  	return 0;
>  }

-- 
Jeff Layton <jlayton@redhat.com>

