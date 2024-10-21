Return-Path: <ceph-devel+bounces-1912-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE3C9A944B
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2024 01:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D31861F22CF9
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Oct 2024 23:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E571FF7DC;
	Mon, 21 Oct 2024 23:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Kzfj3jpq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB991FF5EB
	for <ceph-devel@vger.kernel.org>; Mon, 21 Oct 2024 23:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729553993; cv=none; b=bhwoSiSgV6UwB8jREeDuwA/BzmeFIrdfN/UgRHfdlPCiNkhyWcDOovKf+6XzFGEdhAcACKeDOWyyowmY6/lkP0ld2bpuBFgcMpJQH+vkfEF1E1Jy65mmaTzBNcKw7Ey7KdV9h/We6zlL8vbaSrHkQ5HBCg5gzOx6bwfLPNcdfx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729553993; c=relaxed/simple;
	bh=q1QmvXn6GwPcneGjGwPv0xmS4RRUjRFacDa92Vsp7Kw=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=eEgPQjn3KElr3H+lJAdRpo1ne0SHwTcngYJCrJqt3DR5VOHxFwrAmblmUXdq6WQ/7Uj+mPLckNdu/XVR1LbBHN7S46dRIV7soOXVKeACZmQD1j7p7NVUf5zbVNuScb20kIHzU2U06pEm8QikNXTibKSTCOILczNCx/BSkYz4MHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Kzfj3jpq; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7b155cca097so329455285a.1
        for <ceph-devel@vger.kernel.org>; Mon, 21 Oct 2024 16:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1729553990; x=1730158790; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7tHUckLE/MLiHUlkx0kAjj3yltxCb3kfPASiHLjhco=;
        b=Kzfj3jpq5Gs6Iyof3iA7rovfU2wLkd9Tl9jotb42aKAxDv1hEyEWdJFW3Yl2oB9wi4
         x+UYwFcHG5FTNw3OiuzdHqfFrDDlTTo9vkfe+S8/KQv2aAYcRkn9Ac+IULwekeeQhaYu
         VJQaLNUNKeDcAKFZFoIcHiHNd4ur112PjTRwcDC/+g+UXtBx5MK0x6IOtsmfONfbBxei
         4oqqOZ2g71XbJCpB1IH8cuBNPO+RGSMvCw8z0/V5b90L3YJ3/htlYjsS0P0+BNx+PjKU
         y+Rfo7VyX4lNQkeCqX0TcvolcjJWOtv7yrDRIdyHXCtek63tYyZPcPWkitTkHo2S/nUu
         zAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729553990; x=1730158790;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X7tHUckLE/MLiHUlkx0kAjj3yltxCb3kfPASiHLjhco=;
        b=T8xfMya88Zfkiql6XdbysiSUPaM053F3wpDytUpmhA67R3XpsOsoXlNQBByPEsHYOz
         KAO6Xe4uCnUej/Evq0Fb6Xn2V7Z5kS+FdE/BiERpLzigdltImwWt+EY/Oaw4fChLw+NP
         yCmNIQxO9RrmO00TuiAGwDtU3fMPr/6+mPR3UrRnrVfsuYJOPpicqZPndDd8/h4mcTmX
         JAvC9VwO1eKD7M4g7zEOes0kbwcKORY30y0IQ3xI/9m2lF5oUzzOsKR8qTGOLLEfFDIR
         XhDaEq58z3AOppzGBTdsvbRJ3jtwFj0k6hTpsCzAeEP2NWoHMswgjR3KMHI2oRZ/ApNl
         YZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDQEaX4R9mqNXmpHo34WOOHapH6ihtPRYrKcv6FeJVf0m3j9WRkH+DR7lzOSNFEsQ/8YyIYZf/pTlN@vger.kernel.org
X-Gm-Message-State: AOJu0YzXCnUFA/LX89/2EtOtA44ycC/NQKXTX01UACfp1LmwlHAJzO+Y
	dZzb9IH0Pbt1JOSZJRjDSGagGG1J64i4bwdoBLeSiPGdBib1QH5cfynohDbDJA==
X-Google-Smtp-Source: AGHT+IHMuRe4JiqCCfpTVHmSm+FewrxBnBkGSC7Nzs4TDMNE+u2iWG54d8b/+ap0PMLoJ5C40bnP5Q==
X-Received: by 2002:a05:620a:1928:b0:7ac:e8bf:894a with SMTP id af79cd13be357-7b1755db38cmr237177885a.20.1729553990490;
        Mon, 21 Oct 2024 16:39:50 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b1659c88f1sm226044385a.17.2024.10.21.16.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 16:39:50 -0700 (PDT)
Date: Mon, 21 Oct 2024 19:39:49 -0400
Message-ID: <b94aa34a25a19ea729faa1c8240ebf5b@paul-moore.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20241021_1626/pstg-lib:20241021_1624/pstg-pwork:20241021_1626
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>, casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, serge@hallyn.com, keescook@chromium.org, john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp, stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org, selinux@vger.kernel.org, mic@digikod.net, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 4/6] LSM: lsm_context in security_dentry_init_security
References: <20241014151450.73674-5-casey@schaufler-ca.com>
In-Reply-To: <20241014151450.73674-5-casey@schaufler-ca.com>

On Oct 14, 2024 Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> Replace the (secctx,seclen) pointer pair with a single lsm_context
> pointer to allow return of the LSM identifier along with the context
> and context length. This allows security_release_secctx() to know how
> to release the context. Callers have been modified to use or save the
> returned data from the new structure.
> 
> Special care is taken in the NFS code, which uses the same data structure
> for its own copied labels as it does for the data which comes from
> security_dentry_init_security().  In the case of copied labels the data
> has to be freed, not released.
> 
> The scaffolding funtion lsmcontext_init() is no longer needed and is
> removed.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-nfs@vger.kernel.org
> ---
>  fs/ceph/super.h               |  3 +--
>  fs/ceph/xattr.c               | 16 ++++++----------
>  fs/fuse/dir.c                 | 35 ++++++++++++++++++-----------------
>  fs/nfs/dir.c                  |  2 +-
>  fs/nfs/inode.c                | 17 ++++++++++-------
>  fs/nfs/internal.h             |  8 +++++---
>  fs/nfs/nfs4proc.c             | 22 +++++++++-------------
>  fs/nfs/nfs4xdr.c              | 22 ++++++++++++----------
>  include/linux/lsm_hook_defs.h |  2 +-
>  include/linux/nfs4.h          |  8 ++++----
>  include/linux/nfs_fs.h        |  2 +-
>  include/linux/security.h      | 26 +++-----------------------
>  security/security.c           |  9 ++++-----
>  security/selinux/hooks.c      |  9 +++++----
>  14 files changed, 80 insertions(+), 101 deletions(-)

...

> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index 039898d70954..47652d217d05 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -457,7 +457,7 @@ static inline void nfs4_label_free(struct nfs4_label *label)
>  {
>  #ifdef CONFIG_NFS_V4_SECURITY_LABEL
>  	if (label) {
> -		kfree(label->label);
> +		kfree(label->lsmctx.context);

Shouldn't this be a call to security_release_secctx() instead of a raw
kfree()?

>  		kfree(label);
>  	}
>  #endif

--
paul-moore.com

