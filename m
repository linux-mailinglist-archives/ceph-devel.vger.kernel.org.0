Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6D93F1ED1
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhHSRRF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 13:17:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhHSRRF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 13:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629393388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AR7Ev0c/xWEcFRERTRR/8j7IXtil1ytjSRA4mHK4YSo=;
        b=SNbbJEkhXyKpwcfchPNlz35WauJozQrZUNZtxha2B/a9MJzaJk1cLozxRr1fiAMecDr3QN
        yhteOgyPf5JoBxZeMyWpTofIMCMxjGJYDQQJ+RWrQ6BDnRYF89dqA4sCiB0+1CsLDD9JLr
        2OsEMPE6ZU7FVUbaUaR20V7nVz9DUyM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-hvaI1W7xNd-lxx0cgDUjQg-1; Thu, 19 Aug 2021 13:16:26 -0400
X-MC-Unique: hvaI1W7xNd-lxx0cgDUjQg-1
Received: by mail-qv1-f72.google.com with SMTP id n5-20020a056214008500b0035b6a75b52eso4976398qvr.3
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 10:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AR7Ev0c/xWEcFRERTRR/8j7IXtil1ytjSRA4mHK4YSo=;
        b=U4k4UVz2+q8ilj4FmqxFiXmEnuXB2D96kkW0o4SL2ITEspdyG2vyVOghcb4lBH+nF7
         TkqytHCl7IX2fy69TXPO+NvRBHJYNUffi+9aeVuWJNEbpspVZqlurWbisjbEt0+7aWjA
         8D7vGSWmB0/NyIN2y72Jlqk+hAyaFZD7+f7NDWtYcdTdpetMQrcy94U0l55+uBzbcYCt
         YJBcjX8Cu/l9flAXT9RvtGL+fA6rtKJefRY2V/sTcSkFwrkX+L4avbxelvdLZBzhG5Eo
         n8YqAPuMttyj6ISzTJ/QwFoBwTigW2z6DollhfwxiTj0smKGFjXrDhBZL+mxEiiT3EzQ
         ROEA==
X-Gm-Message-State: AOAM533lVBtz9fhPogL5pfCYHz23wsa3ZxMpYKK5vIrYADAEif3WU9uu
        /yuwE7dBqoasBx0RlkO9UMZaoirp1w0eGS4VS+NU8/8hoy4GVDnDLszuQ6P/xK+6gpnBc7tvZZV
        erNcPTIim8f0Dv2N2OmTI/w==
X-Received: by 2002:a0c:b2d5:: with SMTP id d21mr15693833qvf.33.1629393386510;
        Thu, 19 Aug 2021 10:16:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgEQ3E8cB9TO2DRGaDJp7df9j8ORtofV+0+IJ0MgTRUzgiRis1yaMkftayux17S7QqP67TDg==
X-Received: by 2002:a0c:b2d5:: with SMTP id d21mr15693816qvf.33.1629393386364;
        Thu, 19 Aug 2021 10:16:26 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id a22sm1521346qtw.59.2021.08.19.10.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 10:16:26 -0700 (PDT)
Message-ID: <9891128997ecdd7a2b9c88b3a7271936f5d66fd7.camel@redhat.com>
Subject: Re: [PATCH 1/2] ceph: add helpers to create/cleanup debugfs
 sub-directories under "ceph" directory
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Thu, 19 Aug 2021 13:16:25 -0400
In-Reply-To: <20210819060701.25486-2-vshankar@redhat.com>
References: <20210819060701.25486-1-vshankar@redhat.com>
         <20210819060701.25486-2-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-19 at 11:37 +0530, Venky Shankar wrote:
> Callers can use this helper to create a subdirectory under
> "ceph" directory in debugfs to place custom files for exporting
> information to userspace.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  include/linux/ceph/debugfs.h |  3 +++
>  net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
> index 8b3a1a7a953a..c372e6cb8aae 100644
> --- a/include/linux/ceph/debugfs.h
> +++ b/include/linux/ceph/debugfs.h
> @@ -10,5 +10,8 @@ extern void ceph_debugfs_cleanup(void);
>  extern void ceph_debugfs_client_init(struct ceph_client *client);
>  extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
>  
> +extern struct dentry *ceph_debugfs_create_subdir(const char *subdir);
> +extern void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry);
> +
>  #endif
>  
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 2110439f8a24..cd6f69dd97fa 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -404,6 +404,18 @@ void ceph_debugfs_cleanup(void)
>  	debugfs_remove(ceph_debugfs_dir);
>  }
>  
> +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> +{
> +	return debugfs_create_dir(subdir, ceph_debugfs_dir);
> +}
> +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> +
> +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> +{
> +	debugfs_remove(subdir_dentry);
> +}
> +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> +

Rather than these specialized helpers, I think it'd be cleaner/more
evident to just export the ceph_debugfs_dir symbol and then use normal
debugfs commands in ceph.ko.

>  void ceph_debugfs_client_init(struct ceph_client *client)
>  {
>  	char name[80];
> @@ -413,7 +425,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
>  
>  	dout("ceph_debugfs_client_init %p %s\n", client, name);
>  
> -	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
> +	client->debugfs_dir = ceph_debugfs_create_subdir(name);
>  
>  	client->monc.debugfs_file = debugfs_create_file("monc",
>  						      0400,
> @@ -454,7 +466,7 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
>  	debugfs_remove(client->debugfs_monmap);
>  	debugfs_remove(client->osdc.debugfs_file);
>  	debugfs_remove(client->monc.debugfs_file);
> -	debugfs_remove(client->debugfs_dir);
> +	ceph_debugfs_cleanup_subdir(client->debugfs_dir);
>  }
>  
>  #else  /* CONFIG_DEBUG_FS */
> @@ -475,4 +487,15 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
>  {
>  }
>  
> +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> +{
> +	return NULL;
> +}
> +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> +
> +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> +{
> +}
> +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> +
>  #endif  /* CONFIG_DEBUG_FS */

-- 
Jeff Layton <jlayton@redhat.com>

