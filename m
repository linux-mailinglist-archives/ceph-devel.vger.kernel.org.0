Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE754A361
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 03:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiFNBCN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 21:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiFNBCM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 21:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82FEC2DA9E
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 18:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655168530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rj2mwv1zdgiRu1HK2i79zkHpfhDnYGDFOQMQkr4iXVM=;
        b=SAt1EoLcznxtxRoodHLbuIOTHlfFGcQM822Rgn6A4GOY/lg8s8YlR3rK85w+KUa5R3o+Dd
        iU179ljZ7VstWi9TCCKGIxQOGKLJHCTRi7KlY9eIHsE2Oey47W1Mx0vJxy3MZWU+sNiFNT
        SrR8a2qm4O4hbkwQR+sH5jfV3wBpky8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-dHJ0yg5lOX6YNxyPGDOV4g-1; Mon, 13 Jun 2022 21:02:09 -0400
X-MC-Unique: dHJ0yg5lOX6YNxyPGDOV4g-1
Received: by mail-pj1-f69.google.com with SMTP id hf12-20020a17090aff8c00b001e2c0a2584cso165410pjb.1
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 18:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Rj2mwv1zdgiRu1HK2i79zkHpfhDnYGDFOQMQkr4iXVM=;
        b=eduzavdKpOHR0vPRZs5KyQ6BonMg5bOidP/JZZys8vRibYeLIKYW3zXnCRwjH14fnW
         0Moi49p6GG5xayP+cRYqHU0F+FMcHb8iTbyTL8FKPbTZyGiPxPcZfS9O4o+LoRcTxM5w
         I8Auy2CKRV9UNjuoAR7i84r/pbxWACXY6VfEtOQvA5RiNuqc9Ej2uoYpY+tAVMHnP3pt
         Uygx/kVekZm/7UyLg4ReW9NzuTY0MTGYuGWDZ/TCC7SYzoxC74jmNLVuku01AJXPh4d4
         AHe+KYOT5QLOeP3RHwnC/SnUi5veancZEOvZHqCJIScgnlTzMaa69g7+4Y7NhUcS21AI
         QkMQ==
X-Gm-Message-State: AJIora/2ZSuZoa73jpafTsrmAq5lKo2WTwdeedFrxgzv/u3ztDJyW6XQ
        /eWywtuedSeV3S7mSZyKkA5c8aMWJ0WPZU9xvyPMNHPqTlvpIpAe5JuFbpkH0yWGbF+ieEQLc2O
        6fP4wrTupEpPyhQ0JJmN5L5QcAzhSdZXOWa/aRPstnYCN36qrqa0t9KlVF08zwURyRBWavJk=
X-Received: by 2002:a17:902:848d:b0:168:ab37:327c with SMTP id c13-20020a170902848d00b00168ab37327cmr2048747plo.112.1655168527436;
        Mon, 13 Jun 2022 18:02:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uHFrs1S7e67sCUytp7r2RXRLzCTY8JFNfUAujy/rQIKGrAf827ao+WTDtAobbTYsIbviK3Uw==
X-Received: by 2002:a17:902:848d:b0:168:ab37:327c with SMTP id c13-20020a170902848d00b00168ab37327cmr2048712plo.112.1655168527024;
        Mon, 13 Jun 2022 18:02:07 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902864900b00168c1668a49sm5752693plt.85.2022.06.13.18.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 18:02:06 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: update the auth cap when the async create req
 is forwarded
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220610043140.642501-1-xiubli@redhat.com>
 <20220610043140.642501-3-xiubli@redhat.com> <87r13seed5.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ca7860a5-0176-15ce-1170-08ec18823921@redhat.com>
Date:   Tue, 14 Jun 2022 09:02:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87r13seed5.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/14/22 12:07 AM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> For async create we will always try to choose the auth MDS of frag
>> the dentry belonged to of the parent directory to send the request
>> and ususally this works fine, but if the MDS migrated the directory
>> to another MDS before it could be handled the request will be
>> forwarded. And then the auth cap will be changed.
>>
>> We need to update the auth cap in this case before the request is
>> forwarded.
>>
>> URL: https://tracker.ceph.com/issues/55857
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c       | 12 +++++++++
>>   fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/super.h      |  2 ++
>>   3 files changed, 72 insertions(+)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 0e82a1c383ca..54acf76c5e9b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>   	struct ceph_mds_reply_inode in = { };
>>   	struct ceph_mds_reply_info_in iinfo = { .in = &in };
>>   	struct ceph_inode_info *ci = ceph_inode(dir);
>> +	struct ceph_dentry_info *di = ceph_dentry(dentry);
>>   	struct timespec64 now;
>>   	struct ceph_string *pool_ns;
>>   	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>> @@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>   		file->f_mode |= FMODE_CREATED;
>>   		ret = finish_open(file, dentry, ceph_open);
>>   	}
>> +
>> +	spin_lock(&dentry->d_lock);
>> +	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
>> +	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
>> +	spin_unlock(&dentry->d_lock);
> Question: shouldn't we initialise 'di' *after* grabbing ->d_lock?  Ceph
> code doesn't seem to be consistent with this regard, but my understanding
> is that doing it this way is racy.  And if so, some other places may need
> fixing.

BTW, do you mean some where like:

'if (!test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags))' and 'di->hnode' ?

If so, it's okay and no issue here.

-- Xiubo


> Cheers,

