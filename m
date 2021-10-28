Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4843DDAC
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 11:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhJ1J0e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 05:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJ1J0d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 05:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635413046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6wxxLnlktQ5gLLh5qEf/D4R3X3Ds5X1OxCWmUWS8e50=;
        b=PTs5gz94wUGYkhl+8fbBSOQLUkfPfrR27/kl1E3m/jQf8lJQGejBGufiMr1YMTJ9XRJqNc
        AaDaGUXg8CaO+ikEL53I594zAjSgtLK3VabhrVo51WskueYK9zG05enmoGfgTnLv6D7CtY
        d9VD0CIQIZsUMiZn7TmQ3KAhzoOiI4M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-j81Wv4afNASE_vJMB2ttQA-1; Thu, 28 Oct 2021 05:24:05 -0400
X-MC-Unique: j81Wv4afNASE_vJMB2ttQA-1
Received: by mail-pl1-f199.google.com with SMTP id 12-20020a170902c10c00b0014167ea00cbso2483751pli.9
        for <ceph-devel@vger.kernel.org>; Thu, 28 Oct 2021 02:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6wxxLnlktQ5gLLh5qEf/D4R3X3Ds5X1OxCWmUWS8e50=;
        b=eIhm75FzAwaRGCw34VBMLTnaz7HiY81UDRgB/oxuFBDriwsUrdQZxhEuIKnofeRNM7
         rD4yMJJaHpSk+I/Vh0+sSRKu23rfgIzeXMj25A6+8kMsQjBR6wARiAKRfLyfJeVnM4gC
         LAYVgYrkgBtVZwDdiOmHFzLiRlK7qTNsDcTWrtTGt0gj7Ub7CmBCer7TK1kkF34NRryA
         +DtnFjaSHd7BYYa4AkV3Q0GROsv7P/3eHWjvoWMg2ZyaBYn1qNEpfcyZvVZqIsE8c3np
         Dy0v/pVVFtveaoFam+5uCoErlz679Of7sH9BaJDVl+yiwx6jIQzi+Dp8JuUf0ei2NO+l
         FMqw==
X-Gm-Message-State: AOAM5317fqu+nu2/6nTg3C/rYFZyLdnhcCkbsudBzJSZUW84WIlhA2nZ
        OK6UjkiPyAaD4iO6cX9IX+nUr9X+IoRF0on+D8W13oXJrE0W574vA6eJidGeu/mO5ehDi50HbzN
        PAz/ZhPPVjsS7l1zTQ7g8IsZ0s3RD6izRdzUNxWGHdjFjQu1Ek6gxI9R4QZvRiH0LXWAK0nc=
X-Received: by 2002:a63:3845:: with SMTP id h5mr2298948pgn.362.1635413044239;
        Thu, 28 Oct 2021 02:24:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsnx2q4VZbuIuLC4KgGLHWKxJGQZjecwN8VsmWeN59faTH6S8P3sh3XVgnWL7OQtLYiAWHQA==
X-Received: by 2002:a63:3845:: with SMTP id h5mr2298923pgn.362.1635413043886;
        Thu, 28 Oct 2021 02:24:03 -0700 (PDT)
Received: from [10.72.12.20] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kk3sm2481721pjb.57.2021.10.28.02.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 02:24:03 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] ceph: add __ceph_get_caps helper support
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-2-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c9255017-333d-68dd-880a-96952e08ca08@redhat.com>
Date:   Thu, 28 Oct 2021 17:23:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211028091438.21402-2-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

Not sure why the cover-letter is not displayed in both the mail list and 
ceph patchwork, locally it was successfully sent out.

Any idea ?

Thanks

-- Xiubo


On 10/28/21 5:14 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c  | 19 +++++++++++++------
>   fs/ceph/super.h |  2 ++
>   2 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d628dcdbf869..4e2a588465c5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2876,10 +2876,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>    * due to a small max_size, make sure we check_max_size (and possibly
>    * ask the mds) so we don't get hung up indefinitely.
>    */
> -int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
> +int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
> +		    int want, loff_t endoff, int *got)
>   {
> -	struct ceph_file_info *fi = filp->private_data;
> -	struct inode *inode = file_inode(filp);
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>   	int ret, _got, flags;
> @@ -2888,7 +2887,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>   	if (ret < 0)
>   		return ret;
>   
> -	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
> +	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
>   	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
>   		return -EBADF;
>   
> @@ -2896,7 +2895,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>   
>   	while (true) {
>   		flags &= CEPH_FILE_MODE_MASK;
> -		if (atomic_read(&fi->num_locks))
> +		if (fi && atomic_read(&fi->num_locks))
>   			flags |= CHECK_FILELOCK;
>   		_got = 0;
>   		ret = try_get_cap_refs(inode, need, want, endoff,
> @@ -2941,7 +2940,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>   				continue;
>   		}
>   
> -		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
> +		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
>   		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
>   			if (ret >= 0 && _got)
>   				ceph_put_cap_refs(ci, _got);
> @@ -3004,6 +3003,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>   	return 0;
>   }
>   
> +int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
> +{
> +	struct ceph_file_info *fi = filp->private_data;
> +	struct inode *inode = file_inode(filp);
> +
> +	return __ceph_get_caps(inode, fi, need, want, endoff, got);
> +}
> +
>   /*
>    * Take cap refs.  Caller must already know we hold at least one ref
>    * on the caps in question or we don't know this is safe.
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 7f3976b3319d..027d5f579ba0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1208,6 +1208,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
>   				      struct inode *dir,
>   				      int mds, int drop, int unless);
>   
> +extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
> +			   int need, int want, loff_t endoff, int *got);
>   extern int ceph_get_caps(struct file *filp, int need, int want,
>   			 loff_t endoff, int *got);
>   extern int ceph_try_get_caps(struct inode *inode,

