Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6961F4EBF0A
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 12:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245507AbiC3Kos (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 06:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245505AbiC3Kor (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 06:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36CA4269367
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648636981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2YDt5FkmAHELTyccuNt8deKhuBeooN2AAbjTBZhq7Rg=;
        b=WTIbgwFlrip3tNcEwXIQBwJsam+7Vko1k5ATSaQKROXagElNHBGtx5eOE1HibeSBL9Ju6j
        cd450uyf3THhx1tcKE957aZk+84lNsAAQ2Y7mRzNaO8cFEX5JFuDkDLnj6b3vb3RnHWQnu
        1Od84qHsIKmgSK7iyD9d+6UKs4L2Jlw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100--cFOtFA2M1u2LbdA6nq9WQ-1; Wed, 30 Mar 2022 06:43:00 -0400
X-MC-Unique: -cFOtFA2M1u2LbdA6nq9WQ-1
Received: by mail-pf1-f198.google.com with SMTP id t66-20020a625f45000000b004fabd8f5cc1so11833224pfb.11
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2YDt5FkmAHELTyccuNt8deKhuBeooN2AAbjTBZhq7Rg=;
        b=vov3TxsCHkkhXi1Df+L0IpKmkCo8t6b2Mf2Q1xBXHzijX3vURCmQ3gHq5WjvYuG5UD
         MjFDg9cEEujgPOnOJpaG49N3qrHj4DVxCO9TLWFzkZ9JmzDEsQjcCOqam4p+6H8pmBO9
         p/rGf34rfcXMZzmpJkTn7c+9OIcgcAAhbEqy/Sir2mwSn0i4OdAksCbznKfIoe5cM6sK
         1m4oVi8pUAISOzbge8senbZbwTpQlEnlWNfw7sM6AOGh33nRo7WiaYT3Myz0gBZG88kc
         Rkw51/JRVroZC6TDyDP8i2cxnotk/1kYCRrdfS4Nabo+odS8A4X0GxtwQaN7Wj7b0oyr
         HNTg==
X-Gm-Message-State: AOAM5323jGOxpWWLvC0bTXuy7tjcDTuKKNieUiyqP3aCddKH7ySmJLTk
        dlQUNIYF3PEZgNdlidKY0Hi18sOWAktOpB8infoTv0LXK0OGiJQZN3RVqwT0zVZAr+JDNtSkxxM
        Hf9RO1ZNp65mj5bBB3J64Dtz0MTghC9UUvaXtzmpROJNniI+uy7fMlvGf/ZvcjxjjL5p8ZHY=
X-Received: by 2002:a17:90a:d302:b0:1c9:9204:136a with SMTP id p2-20020a17090ad30200b001c99204136amr4214721pju.136.1648636978587;
        Wed, 30 Mar 2022 03:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFiy+5puOVNowvwBkPt5j5yE6Tz2x9inj5TCOjV7LDdufGuXuMuxUy9KUUWZkb37nZKV4kFg==
X-Received: by 2002:a17:90a:d302:b0:1c9:9204:136a with SMTP id p2-20020a17090ad30200b001c99204136amr4214685pju.136.1648636978170;
        Wed, 30 Mar 2022 03:42:58 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm5987220pjb.53.2022.03.30.03.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 03:42:57 -0700 (PDT)
Subject: Re: [PATCH] ceph: update the dlease for the hashed dentry when
 removing
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220330054956.271022-1-xiubli@redhat.com>
 <6046490a385d690326efe4c3a3396bfdf2fed4c9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <45bee165-cdb4-ebb9-3adb-43dd663cc5c5@redhat.com>
Date:   Wed, 30 Mar 2022 18:42:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6046490a385d690326efe4c3a3396bfdf2fed4c9.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/30/22 6:39 PM, Jeff Layton wrote:
> On Wed, 2022-03-30 at 13:49 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The MDS will always refresh the dentry lease when removing the files
>> or directories. And if the dentry is still hashed, we can update
>> the dentry lease and no need to do the lookup from the MDS later.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 64b341f5e7bc..8cf55e6e609e 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -1467,10 +1467,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>>   			} else if (have_lease) {
>>   				if (d_unhashed(dn))
>>   					d_add(dn, NULL);
>> +			}
>> +
>> +			if (!d_unhashed(dn) && have_lease)
>>   				update_dentry_lease(dir, dn,
>>   						    rinfo->dlease, session,
>>   						    req->r_request_started);
>> -			}
>>   			goto done;
>>   		}
>>   
> I think this makes sense, since we can have a lease for a negative
> dentry.

Yeah, from the logs there really has many case will do that.

Thanks Jeff.

>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>

