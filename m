Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14FF3BF647
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 09:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhGHHdi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 03:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhGHHdi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 03:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625729456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQ3j7II9/cxdFOZoPulB4KXTYjcgvmPvQ6tfrIkSS+Y=;
        b=N4arayoummB9lfmncktAfToYHgOVh3gxqIl8iWlYRI0wWhexzqds4jKQ7YVaaolpdnjLUM
        bIsrL6a4yJyG8QBIvG4Ig/Uw4tpHmAXaS5vo1AP92XhBsDbfhhEvRzpzIhN7m6BC9JOvIU
        Wyn9+jZtrzSoSwToVGZwXp/xv+n1+8w=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-pSpZqsFZMG6V9XiBJA_qTw-1; Thu, 08 Jul 2021 03:30:55 -0400
X-MC-Unique: pSpZqsFZMG6V9XiBJA_qTw-1
Received: by mail-pj1-f69.google.com with SMTP id t5-20020a17090a4485b029016f7fcb8a3dso3233366pjg.2
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 00:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iQ3j7II9/cxdFOZoPulB4KXTYjcgvmPvQ6tfrIkSS+Y=;
        b=Y/+0fpsN0o5omxZ+ZABa+XdTrr3gkRdsoBjMuWyOy+6DQqfD66otXacPczud2AXsp1
         Ce8HPe3WCvIVyte7Qm7SWQlgIZqR/s24uhK6TIPWBkYY22PyVY5mvL9hymS16B/ftE9v
         D+y2d2JoyoiiXl4GOf0WX6y1O1e8p30Nr3rw/cjygG+Jp1pBfwR0TXKrw9vVeYzK4xbK
         oaDgSzqRxHdcd7722BG7sXQCbxU6sNprFV3PTn3Qy8Hb/RAld2F8so3GadehGpmqACl9
         1iPrXPXArqIZqaWmrzuClqi7OzwnPOAxqqd9ebTOvp2KuEZ3w6wN6Rks4mBIfp5R8xEl
         Og5Q==
X-Gm-Message-State: AOAM533xUifdZIsJOnZuITnhUuSmYOBGa6MYL4yg7j0gckDntzMF5cfv
        v/2iFkkrICwkVdBkqFE7hbPT6G8N5+aQaRbZjg0L7xuiCTadGbajmoPn3I6/25RVfKZCOf8H8q+
        wja5bo+zCzlIAlqxtFPHXsQ==
X-Received: by 2002:a17:90b:374d:: with SMTP id ne13mr8961547pjb.124.1625729454497;
        Thu, 08 Jul 2021 00:30:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYQxYqScYWNkafWNecBlMJH7knSCGhaLBW9SRe+1fl7qwUIe/FuKgzmVT/Z/z3BHM6V/mpaQ==
X-Received: by 2002:a17:90b:374d:: with SMTP id ne13mr8961516pjb.124.1625729454189;
        Thu, 08 Jul 2021 00:30:54 -0700 (PDT)
Received: from [10.72.12.159] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm1891619pga.72.2021.07.08.00.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 00:30:53 -0700 (PDT)
Subject: Re: [RFC PATCH v7 12/24] ceph: add fscrypt ioctls
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, dhowells@redhat.com
References: <20210625135834.12934-1-jlayton@kernel.org>
 <20210625135834.12934-13-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <912b5949-ae85-f093-0f23-0650aad606fc@redhat.com>
Date:   Thu, 8 Jul 2021 15:30:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625135834.12934-13-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/25/21 9:58 PM, Jeff Layton wrote:
> We gate most of the ioctls on MDS feature support. The exception is the
> key removal and status functions that we still want to work if the MDS's
> were to (inexplicably) lose the feature.
>
> For the set_policy ioctl, we take Fcx caps to ensure that nothing can
> create files in the directory while the ioctl is running. That should
> be enough to ensure that the "empty_dir" check is reliable.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/ioctl.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
>
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 6e061bf62ad4..477ecc667aee 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -6,6 +6,7 @@
>   #include "mds_client.h"
>   #include "ioctl.h"
>   #include <linux/ceph/striper.h>
> +#include <linux/fscrypt.h>
>   
>   /*
>    * ioctls
> @@ -268,8 +269,54 @@ static long ceph_ioctl_syncio(struct file *file)
>   	return 0;
>   }
>   
> +static int vet_mds_for_fscrypt(struct file *file)
> +{
> +	int i, ret = -EOPNOTSUPP;
> +	struct ceph_mds_client	*mdsc = ceph_sb_to_mdsc(file_inode(file)->i_sb);
> +
> +	mutex_lock(&mdsc->mutex);
> +	for (i = 0; i < mdsc->max_sessions; i++) {
> +		struct ceph_mds_session *s = mdsc->sessions[i];
> +
> +		if (!s)
> +			continue;
> +		if (test_bit(CEPHFS_FEATURE_ALTERNATE_NAME, &s->s_features))
> +			ret = 0;
> +		break;
> +	}
> +	mutex_unlock(&mdsc->mutex);
> +	return ret;
> +}
> +
> +static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
> +{
> +	int ret, got = 0;
> +	struct inode *inode = file_inode(file);
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	ret = vet_mds_for_fscrypt(file);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Ensure we hold these caps so that we _know_ that the rstats check
> +	 * in the empty_dir check is reliable.
> +	 */
> +	ret = ceph_get_caps(file, CEPH_CAP_FILE_SHARED, 0, -1, &got);

In the commit comment said it will host the Fsx, but here it is only 
trying to hold the Fs. Will the Fx really needed ?

Thanks


> +	if (ret)
> +		return ret;
> +
> +	ret = fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> +	if (got)
> +		ceph_put_cap_refs(ci, got);
> +
> +	return ret;
> +}
> +
>   long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   {
> +	int ret;
> +
>   	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
>   	switch (cmd) {
>   	case CEPH_IOC_GET_LAYOUT:
> @@ -289,6 +336,42 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   
>   	case CEPH_IOC_SYNCIO:
>   		return ceph_ioctl_syncio(file);
> +
> +	case FS_IOC_SET_ENCRYPTION_POLICY:
> +		return ceph_set_encryption_policy(file, arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_POLICY:
> +		ret = vet_mds_for_fscrypt(file);
> +		if (ret)
> +			return ret;
> +		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> +		ret = vet_mds_for_fscrypt(file);
> +		if (ret)
> +			return ret;
> +		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
> +
> +	case FS_IOC_ADD_ENCRYPTION_KEY:
> +		ret = vet_mds_for_fscrypt(file);
> +		if (ret)
> +			return ret;
> +		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> +
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> +
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
> +		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
> +		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_NONCE:
> +		ret = vet_mds_for_fscrypt(file);
> +		if (ret)
> +			return ret;
> +		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
>   	}
>   
>   	return -ENOTTY;

