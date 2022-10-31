Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C3E61325E
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Oct 2022 10:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJaJQ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Oct 2022 05:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaJQ6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 31 Oct 2022 05:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E380DEA1
        for <ceph-devel@vger.kernel.org>; Mon, 31 Oct 2022 02:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667207762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7c4RHzQOuXVaRtNvZLfvHjb8W5S4vIcXv3YPEcl4G4=;
        b=Cvk+TeuIq2Et+3b1bPbRxbB/uT9pKaawIuxKQ2H9xl0Q7dVDhmUARkcwBWZoQLy8Ne0efO
        Zbwiz8vGwjD/NO+6pEdo0m65/1P3EY0HaRCc/hdCwDu4jhnwa6TvqYkmZwp87l/7L/NJJL
        6y3LNdBBYyJx3BWIysUFITIp7Yklo28=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-tWyZ78UyPciH-BI_pdzCzw-1; Mon, 31 Oct 2022 05:16:00 -0400
X-MC-Unique: tWyZ78UyPciH-BI_pdzCzw-1
Received: by mail-pj1-f72.google.com with SMTP id ci1-20020a17090afc8100b00212e5b4c3afso4060676pjb.3
        for <ceph-devel@vger.kernel.org>; Mon, 31 Oct 2022 02:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7c4RHzQOuXVaRtNvZLfvHjb8W5S4vIcXv3YPEcl4G4=;
        b=39I95YhKw05AB0etyVRzSu1THxJVx75eWyKok5x3GWVlIQVmMb47uV8of5nfJioLPL
         iwnV0ETLKTl2amM8pgywSxmSjMiRPjgfwTtRpvHQzsCvdSgnlEQGIS66tuX/1SXLmqn5
         SdasDP9oOyLE5PT47PdQvJgp9Tqrf50hCyoBkcb1BCvo6WL2zpXknYQGDNU+N0ZzKGDs
         7GkjuVsjPXbFyuaypWJxWgTP7cSzYVSBR+wh8hvtOHKTKrl89njNshmqgaUtuMatwRKA
         RTFYUhErTxcYd3hNyoEhlZ5y6hxY7uac6lNxDqPf37MogrPaPcSTxrQjaDe45P8kUC7z
         wDjg==
X-Gm-Message-State: ACrzQf2L/hHAw0szss3Qy5UER0dOxZyru5iemv7rYQCewUTCysZGTd7N
        VNXs834OAbSR/iONSFgyS/Bs9x/97tuQ1wJAKzWeP72AObQd9hLwFdif6SCAnKuui0xHZRKqHHW
        g03I1INkjO4l0zcvOvmasfA==
X-Received: by 2002:a17:902:e1ca:b0:186:878e:3b03 with SMTP id t10-20020a170902e1ca00b00186878e3b03mr13622068pla.95.1667207759437;
        Mon, 31 Oct 2022 02:15:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Y3yfYRZHlNXDqIukMvJPFVIaad4XFGehmfzvWkC9cS65AU5tBw0vLrcZXNslX8jAv14Z2NQ==
X-Received: by 2002:a17:902:e1ca:b0:186:878e:3b03 with SMTP id t10-20020a170902e1ca00b00186878e3b03mr13622056pla.95.1667207759172;
        Mon, 31 Oct 2022 02:15:59 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090a294100b0020d67a726easm3741862pjf.10.2022.10.31.02.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 02:15:58 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: allow encrypting a directory while not having
 Ax caps
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221027112653.12122-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a992d844-6d75-e134-60e1-acb8c8972ff3@redhat.com>
Date:   Mon, 31 Oct 2022 17:15:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221027112653.12122-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 27/10/2022 19:26, Luís Henriques wrote:
> If a client doesn't have Fx caps on a directory, it will get errors while
> trying encrypt it:
>
> ceph: handle_cap_grant: cap grant attempt to change fscrypt_auth on non-I_NEW inode (old len 0 new len 48)
> fscrypt (ceph, inode 1099511627812): Error -105 getting encryption context
>
> A simple way to reproduce this is to use two clients:
>
>      client1 # mkdir /mnt/mydir
>
>      client2 # ls /mnt/mydir
>
>      client1 # fscrypt encrypt /mnt/mydir
>      client1 # echo hello > /mnt/mydir/world
>
> This happens because, in __ceph_setattr(), we only initialize
> ci->fscrypt_auth if we have Ax.  If we don't have, we'll need to do that
> later, in handle_cap_grant().
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi!
>
> To be honest, I'm not really sure about the conditions in the 'if': shall
> I bother checking it's really a dir and that it is empty?
>
> Cheers,
> --
> Luís
>
>   fs/ceph/caps.c | 26 +++++++++++++++++++++++---
>   1 file changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 443fce066d42..e33b5c276cf3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3511,9 +3511,29 @@ static void handle_cap_grant(struct inode *inode,
>   		     from_kuid(&init_user_ns, inode->i_uid),
>   		     from_kgid(&init_user_ns, inode->i_gid));
>   #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
> -		if (ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
> -		    memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
> -			   ci->fscrypt_auth_len))
> +		if ((ci->fscrypt_auth_len == 0) &&
> +		    (extra_info->fscrypt_auth_len > 0) &&
> +		    S_ISDIR(inode->i_mode) &&
> +		    (ci->i_rsubdirs + ci->i_rfiles == 1)) {
> +			/*
> +			 * We'll get here when setting up an encrypted directory
> +			 * but we don't have Fx in that directory, i.e. other
> +			 * clients have accessed this directory too.
> +			 */
> +			ci->fscrypt_auth = kmemdup(extra_info->fscrypt_auth,
> +						   extra_info->fscrypt_auth_len,
> +						   GFP_KERNEL);
> +			if (ci->fscrypt_auth) {
> +				inode->i_flags |= S_ENCRYPTED;
> +				ci->fscrypt_auth_len = extra_info->fscrypt_auth_len;
> +			} else {
> +				pr_err("Failed to alloc memory for %llx.%llx fscrypt_auth\n",
> +					ceph_vinop(inode));
> +			}
> +			dout("ino %llx.%llx is now encrypted\n", ceph_vinop(inode));
> +		} else if (ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
> +			   memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
> +				  ci->fscrypt_auth_len))
>   			pr_warn_ratelimited("%s: cap grant attempt to change fscrypt_auth on non-I_NEW inode (old len %d new len %d)\n",
>   				__func__, ci->fscrypt_auth_len, extra_info->fscrypt_auth_len);
>   #endif

Hi Luis,

Thanks for your time on this bug.

IMO we should fix this in ceph_fill_inode():

  995 #ifdef CONFIG_FS_ENCRYPTION
  996         if (iinfo->fscrypt_auth_len && (inode->i_state & I_NEW)) {
  997                 kfree(ci->fscrypt_auth);
  998                 ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
  999                 ci->fscrypt_auth = iinfo->fscrypt_auth;
1000                 iinfo->fscrypt_auth = NULL;
1001                 iinfo->fscrypt_auth_len = 0;
1002                 inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
1003         }
1004 #endif

The setattr will get a reply from MDS including the fscrypt auth info, I 
think the kclient just drop it here.

If we fix it in handle_cap_grant() I am afraid this bug still exists. 
What if there is no any new caps will be issued or revoked recently and 
then access to the directory ?

Thanks

- Xiubo

>

