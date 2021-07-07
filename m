Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB583BE37D
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jul 2021 09:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhGGHXn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jul 2021 03:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230340AbhGGHXm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jul 2021 03:23:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625642462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JVItEaca5YaB0eGRbcAWbtm7kkQ+4ze3OhCdChVWAKo=;
        b=GvkWolC1FVrRENPAspwsTIqI87eWZQ/R+j6DLMtz0YPob1Z1M0oCnuFedW0a5lNoGmV73K
        ojxZ7vWnzx8FR2endnXtrSP8pI030LgxD8n3G5yxs/X1c4U+V/40EpGYCS2AftrvDaV0Wb
        9KzmdSSW6quYBF+ZZsdY7u7yzhjqEGs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-PfiqiBQdOmugbYSA-Q0LLw-1; Wed, 07 Jul 2021 03:20:59 -0400
X-MC-Unique: PfiqiBQdOmugbYSA-Q0LLw-1
Received: by mail-pj1-f71.google.com with SMTP id k92-20020a17090a14e5b02901731af08bd7so998136pja.2
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jul 2021 00:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JVItEaca5YaB0eGRbcAWbtm7kkQ+4ze3OhCdChVWAKo=;
        b=CDpKPMxfFoxsaAthYOl5fNd670tqfB9d7FdVwX5A1FDPuZcAbK76cv817BckhBilvJ
         24+AzQ9Bkvza55EEzRDNZonIkHVlDn0buUZwZmU/rNzMCCcSwC461ehqOxBv8WBrKL2y
         Z8HRqVmaMcGT7V1tgnpQfukOiOxNkCAUFAfTcb3FdxODGUVOxnW5JpXk53coeDlEUE+9
         lBxgl1EsRCSwMPhjBbXxao8prAvVbThELjABho81Z9xnP+w1D3g3Oj7D03gqNnxEZ9vN
         3cTCxKmr3luqxaIDNZahOeEufl1nybZJuNVEFuwP3tiYbQdrMPaYiLTJD+9APjX70anJ
         gxgg==
X-Gm-Message-State: AOAM532pt8XlaSrGcUWqLO8XSotzJd4Gun4F4UASsHdcKP0k/y5ouom5
        ZktksxdY1sa5Van/By9A1hZjxJvfuRVE2xe2JKN9dOpx5A50cx96DHfQAEUQtqBS8E5TtdUeTnU
        T4a1ANWvh1ShJsb32lLVkXA==
X-Received: by 2002:a63:ed0a:: with SMTP id d10mr25094235pgi.82.1625642457967;
        Wed, 07 Jul 2021 00:20:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym9qzlVOMlWeGQxXTNPsvP16/7VTMX+07vEjASq04q0/gub3/eK04T09UQp9dw+mBrCmoLWg==
X-Received: by 2002:a63:ed0a:: with SMTP id d10mr25094214pgi.82.1625642457686;
        Wed, 07 Jul 2021 00:20:57 -0700 (PDT)
Received: from [10.72.12.117] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w123sm19561385pff.152.2021.07.07.00.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 00:20:57 -0700 (PDT)
Subject: Re: [RFC PATCH v7 07/24] ceph: add fscrypt_* handling to caps.c
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, dhowells@redhat.com
References: <20210625135834.12934-1-jlayton@kernel.org>
 <20210625135834.12934-8-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f8c7dc0f-49ee-2c25-8e41-e47557db80e4@redhat.com>
Date:   Wed, 7 Jul 2021 15:20:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625135834.12934-8-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

There has some following patches in your "fscrypt" branch, which is not 
posted yet, the commit is:

"3161d2f549db ceph: size handling for encrypted inodes in cap updates"

It seems buggy.

In the encode_cap_msg() you have removed the 'fscrypt_file_len' and and 
added a new 8 bytes' data encoding:

         ceph_encode_32(&p, arg->fscrypt_auth_len);
         ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
-       ceph_encode_32(&p, arg->fscrypt_file_len);
-       ceph_encode_copy(&p, arg->fscrypt_file, arg->fscrypt_file_len);
+       ceph_encode_32(&p, sizeof(__le64));
+       ceph_encode_64(&p, fc->size);

That means no matter the 'arg->encrypted' is true or not, here it will 
always encode extra 8 bytes' data ?


But in cap_msg_size(), you are making it optional:


  static inline int cap_msg_size(struct cap_msg_args *arg)
  {
         return CAP_MSG_FIXED_FIELDS + arg->fscrypt_auth_len +
-                       arg->fscrypt_file_len;
+                       arg->encrypted ? sizeof(__le64) : 0;
  }


Have I missed something important here ?

Thanks


On 6/25/21 9:58 PM, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 62 +++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 49 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 038f59cc4250..1be6c5148700 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -13,6 +13,7 @@
>   #include "super.h"
>   #include "mds_client.h"
>   #include "cache.h"
> +#include "crypto.h"
>   #include <linux/ceph/decode.h>
>   #include <linux/ceph/messenger.h>
>   
> @@ -1229,15 +1230,12 @@ struct cap_msg_args {
>   	umode_t			mode;
>   	bool			inline_data;
>   	bool			wake;
> +	u32			fscrypt_auth_len;
> +	u32			fscrypt_file_len;
> +	u8			fscrypt_auth[sizeof(struct ceph_fscrypt_auth)]; // for context
> +	u8			fscrypt_file[sizeof(u64)]; // for size
>   };
>   
> -/*
> - * cap struct size + flock buffer size + inline version + inline data size +
> - * osd_epoch_barrier + oldest_flush_tid
> - */
> -#define CAP_MSG_SIZE (sizeof(struct ceph_mds_caps) + \
> -		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4)
> -
>   /* Marshal up the cap msg to the MDS */
>   static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
>   {
> @@ -1253,7 +1251,7 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
>   	     arg->size, arg->max_size, arg->xattr_version,
>   	     arg->xattr_buf ? (int)arg->xattr_buf->vec.iov_len : 0);
>   
> -	msg->hdr.version = cpu_to_le16(10);
> +	msg->hdr.version = cpu_to_le16(12);
>   	msg->hdr.tid = cpu_to_le64(arg->flush_tid);
>   
>   	fc = msg->front.iov_base;
> @@ -1324,6 +1322,16 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
>   
>   	/* Advisory flags (version 10) */
>   	ceph_encode_32(&p, arg->flags);
> +
> +	/* dirstats (version 11) - these are r/o on the client */
> +	ceph_encode_64(&p, 0);
> +	ceph_encode_64(&p, 0);
> +
> +	/* fscrypt_auth and fscrypt_file (version 12) */
> +	ceph_encode_32(&p, arg->fscrypt_auth_len);
> +	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
> +	ceph_encode_32(&p, arg->fscrypt_file_len);
> +	ceph_encode_copy(&p, arg->fscrypt_file, arg->fscrypt_file_len);
>   }
>   
>   /*
> @@ -1445,6 +1453,26 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>   		}
>   	}
>   	arg->flags = flags;
> +	if (ci->fscrypt_auth_len &&
> +	    WARN_ON_ONCE(ci->fscrypt_auth_len != sizeof(struct ceph_fscrypt_auth))) {
> +		/* Don't set this if it isn't right size */
> +		arg->fscrypt_auth_len = 0;
> +	} else {
> +		arg->fscrypt_auth_len = ci->fscrypt_auth_len;
> +		memcpy(arg->fscrypt_auth, ci->fscrypt_auth,
> +			min_t(size_t, ci->fscrypt_auth_len, sizeof(arg->fscrypt_auth)));
> +	}
> +	/* FIXME: use this to track "real" size */
> +	arg->fscrypt_file_len = 0;
> +}
> +
> +#define CAP_MSG_FIXED_FIELDS (sizeof(struct ceph_mds_caps) + \
> +		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4 + 8 + 8 + 4 + 4)
> +
> +static inline int cap_msg_size(struct cap_msg_args *arg)
> +{
> +	return CAP_MSG_FIXED_FIELDS + arg->fscrypt_auth_len +
> +			arg->fscrypt_file_len;
>   }
>   
>   /*
> @@ -1457,7 +1485,7 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
>   	struct ceph_msg *msg;
>   	struct inode *inode = &ci->vfs_inode;
>   
> -	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
> +	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, cap_msg_size(arg), GFP_NOFS, false);
>   	if (!msg) {
>   		pr_err("error allocating cap msg: ino (%llx.%llx) flushing %s tid %llu, requeuing cap.\n",
>   		       ceph_vinop(inode), ceph_cap_string(arg->dirty),
> @@ -1483,10 +1511,6 @@ static inline int __send_flush_snap(struct inode *inode,
>   	struct cap_msg_args	arg;
>   	struct ceph_msg		*msg;
>   
> -	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
> -	if (!msg)
> -		return -ENOMEM;
> -
>   	arg.session = session;
>   	arg.ino = ceph_vino(inode).ino;
>   	arg.cid = 0;
> @@ -1524,6 +1548,18 @@ static inline int __send_flush_snap(struct inode *inode,
>   	arg.flags = 0;
>   	arg.wake = false;
>   
> +	/*
> +	 * No fscrypt_auth changes from a capsnap. It will need
> +	 * to update fscrypt_file on size changes (TODO).
> +	 */
> +	arg.fscrypt_auth_len = 0;
> +	arg.fscrypt_file_len = 0;
> +
> +	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, cap_msg_size(&arg),
> +			   GFP_NOFS, false);
> +	if (!msg)
> +		return -ENOMEM;
> +
>   	encode_cap_msg(msg, &arg);
>   	ceph_con_send(&arg.session->s_con, msg);
>   	return 0;

