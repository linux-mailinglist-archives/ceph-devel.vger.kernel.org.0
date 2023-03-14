Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B4D6B8743
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Mar 2023 01:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCNAyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Mar 2023 20:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCNAyn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Mar 2023 20:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5449691B6A
        for <ceph-devel@vger.kernel.org>; Mon, 13 Mar 2023 17:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678755240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0JsJvgfxeXuomqiITRaXn7QAOEAlk3ESZfXTSZSg34=;
        b=ghRAlWsD+XBiiKIn/jTXT+BbAlqH3roOcghAheciVrerbdxDNLi3xI+6augRyCjQxObAuN
        vuLXr2Ixbx/6pffgp41SUcTaNVeWrt52eCkJnmOI5dMPmkCkChNLmw/q0Tjpf1ll3xW4+Q
        w/0alIS3W7hbumKXNEiQ5xbEVJSu/oY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-VEj7IxsyPDeO31Gh1D5CRA-1; Mon, 13 Mar 2023 20:53:58 -0400
X-MC-Unique: VEj7IxsyPDeO31Gh1D5CRA-1
Received: by mail-pj1-f70.google.com with SMTP id x6-20020a17090aa38600b0023b4895719eso2178252pjp.1
        for <ceph-devel@vger.kernel.org>; Mon, 13 Mar 2023 17:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678755237;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0JsJvgfxeXuomqiITRaXn7QAOEAlk3ESZfXTSZSg34=;
        b=w/+nc+DxlZ3V40Q2ytgFpj4CVccBZl9HF76D+y/ClgJ3oQScFcPv5ob9ATFBoKbHIf
         8e91r530pvW7CTGgG/z35PJ7/WsCCxHQqxrpFZ3iXUXHdUhb7BwFxTlpw3Mjne2HRwSr
         P7P/0yBdmhXsx2tL2q1x5E21xYJNL7iYJC1KuH+/kRXNyZ1uFmHxrvVdj6ofRGBbd6V2
         2whEdHup7WCqUwjABOI9J5zf1yA7/DTftF2oj/ZAOKrI7A33P9WRNsZFm9GkocFvH0C3
         xg9qZm/eWmNsPs07aQg9CAOEOZ9okFNjDIve2RketqVr7wEF8NMs5SZADaWBDKFh4hzc
         /9sA==
X-Gm-Message-State: AO0yUKUAzuuMXHnQ4B9MX7l5a0dqNj9WcGOcTuOB3wunctzeu30+ogEb
        U5KAuMN522NeWSECtE41dS2Co89HH97oOtPq57o8I1U1eBMsRJMANOQ46hvlcIQPKfRxBCyLnom
        rcnW0CC/NUn3j9xj3WtHcWA==
X-Received: by 2002:a17:902:e84c:b0:1a0:616d:7618 with SMTP id t12-20020a170902e84c00b001a0616d7618mr1946707plg.51.1678755237324;
        Mon, 13 Mar 2023 17:53:57 -0700 (PDT)
X-Google-Smtp-Source: AK7set+4xhNMS8rLjRXHFNApIg44pXLbObNkPasVgsTbnY3fm0mlwOpvisr84Yi2Zp4ZwbWF6fan6Q==
X-Received: by 2002:a17:902:e84c:b0:1a0:616d:7618 with SMTP id t12-20020a170902e84c00b001a0616d7618mr1946683plg.51.1678755237028;
        Mon, 13 Mar 2023 17:53:57 -0700 (PDT)
Received: from [10.72.12.147] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z10-20020a170903018a00b001964c8164aasm430433plg.129.2023.03.13.17.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:53:56 -0700 (PDT)
Message-ID: <f72cf7fe-f489-47f2-fab9-be9eee441fca@redhat.com>
Date:   Tue, 14 Mar 2023 08:53:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
 <ZA9mwPUg7H/fq0L8@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ZA9mwPUg7H/fq0L8@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 14/03/2023 02:09, Eric Biggers wrote:
> On Mon, Mar 13, 2023 at 12:33:09PM +0000, Luís Henriques wrote:
>> + * The regular open path will use fscrypt_file_open for that, but in the
>> + * atomic open a different approach is required.
> This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, right?
>
>> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
>> +{
>> +	int err;
>> +
>> +	if (!IS_ENCRYPTED(dir))
>> +		return 0;
>> +
>> +	err = fscrypt_get_encryption_info(dir, true);
>> +	if (!err && !fscrypt_has_encryption_key(dir)) {
>> +		spin_lock(&dentry->d_lock);
>> +		dentry->d_flags |= DCACHE_NOKEY_NAME;
>> +		spin_unlock(&dentry->d_lock);
>> +	}
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
> [...]
>> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
>> +					      struct dentry *dentry)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
> This has different behavior on unencrypted directories depending on whether
> CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.
>
> In patch 2, the caller you are introducing has already checked IS_ENCRYPTED().
>
> Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it is for
> *encrypted* directories.
>
> So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYPTION
> version of fscrypt_prepare_atomic_open().

IMO we should keep this check in fscrypt_prepare_atomic_open() to make 
it consistent with the existing fscrypt_prepare_open(). And we can just 
remove the check from ceph instead.

- Xiubo

> - Eric
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

