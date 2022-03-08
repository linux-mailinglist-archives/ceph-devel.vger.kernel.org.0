Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248C44D1896
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 14:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242757AbiCHNDU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 08:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241987AbiCHNDR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 08:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD03147AE4
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 05:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646744540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cql/HSNomgYV1o8V0OCNLShCieOItyJLG/C4lpfQMRs=;
        b=eY/9kJXqWFjnV0KJZ1RgxoGNCZlas9C+WWFPlRJsHzODKEfFT45EdOFvQd7ZngU/erEyeu
        g/FhgVmH0zLj+KfVNgWTk6G0W4BN4iIlmBjRg0MmW3Tg0Asu8ITdNvplH4frOy+ZQWc29b
        SEiLJqSEISPE43yQxK6JoP83lqCHX5M=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-uNXO09p0Oh2Ilvltkg4OOA-1; Tue, 08 Mar 2022 08:02:18 -0500
X-MC-Unique: uNXO09p0Oh2Ilvltkg4OOA-1
Received: by mail-pl1-f198.google.com with SMTP id u8-20020a170903124800b0015195a5826cso9197967plh.4
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 05:02:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Cql/HSNomgYV1o8V0OCNLShCieOItyJLG/C4lpfQMRs=;
        b=IW4dY+9FjkPt6koNc8DFTJ97M3Xsvuea0ttuolWm2MvBXs/jJu2V2NFYgWrZHuF3n+
         o1q1D4GouRhc80mSbqoYQPpyaeJEv47YCIlc8hRhCeWemBJcdxJHt2fZwZW86INf5D+S
         hlwFz64SF+RhBdPxkd0/dN8EjgXTtlNWm8Ar3PKAKNfOLfRZff3oFt3Hhwli6yr0Y7aW
         EnurLiGcrIQTfe4/pUE7t1tVEwm97WCt4OyQZIpu5QlFl88VRUX6YZKuntLzBchCb2qC
         A6rPJYKrY4oCbSYGwv9kfsRV2/HTXcp+sbnfxmX28WXWmyN2CE6IMZ2qwIRTNiHknjFG
         Udpw==
X-Gm-Message-State: AOAM531HUw3jgVqVUIZE792FbseL6yQKAm5PvPQ5beV0DpT0QEcGkSrN
        Lb4HayYzqQo2HI7fOpEoir1TgL+7V5WYBmQhXvJ3OP7XShtAMKl3r4AXsFtOGVSW60ZXGA5qYlr
        YML/FdqVk/CaxJ7f6TGIwea3q5iMi52K2NJM5QFIbi8prlhTvOeEo+2bF556tsqwl8e/xolM=
X-Received: by 2002:a65:5842:0:b0:374:58b8:2563 with SMTP id s2-20020a655842000000b0037458b82563mr14146734pgr.52.1646744536426;
        Tue, 08 Mar 2022 05:02:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyM4PlWeaDB5nceLxrbgla6QMj2lVp1RfNNFLHu69YB7Zam8GnWsA7MgRNeu5s145lBFvailQ==
X-Received: by 2002:a65:5842:0:b0:374:58b8:2563 with SMTP id s2-20020a655842000000b0037458b82563mr14146697pgr.52.1646744535869;
        Tue, 08 Mar 2022 05:02:15 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13-20020a63e10d000000b003733d6c90e4sm14728548pgh.82.2022.03.08.05.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:02:14 -0800 (PST)
Subject: Re: [RFC PATCH] libceph: wait for con->work to finish when cancelling
 con
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220308095948.1294468-1-xiubli@redhat.com>
 <5c8f08abf692f7f4f4f0112d90c72b8aaa1ab63b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8e6a10af-ee88-12af-537b-f322ff50d93d@redhat.com>
Date:   Tue, 8 Mar 2022 21:02:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5c8f08abf692f7f4f4f0112d90c72b8aaa1ab63b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/8/22 7:45 PM, Jeff Layton wrote:
> On Tue, 2022-03-08 at 17:59 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When reconnecting MDS it will reopen the con with new ip address,
>> but the when opening the con with new address it couldn't be sure
>> that the stale work has finished. So it's possible that the stale
>> work queued will use the new data.
>>
>> This will use cancel_delayed_work_sync() instead.
>>
>> URL: https://tracker.ceph.com/issues/54461
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/messenger.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index d3bb656308b4..32eb5dc00583 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -1416,7 +1416,7 @@ static void queue_con(struct ceph_connection *con)
>>   
>>   static void cancel_con(struct ceph_connection *con)
>>   {
>> -	if (cancel_delayed_work(&con->work)) {
>> +	if (cancel_delayed_work_sync(&con->work)) {
>>   		dout("%s %p\n", __func__, con);
>>   		con->ops->put(con);
>>   	}
> Won't this deadlock?
>
> This function is called from ceph_con_close with the con->mutex held.
> The work will try to take the same mutex and will get stuck. If you want
> to do this, then you may also need to change it to call cancel_con after
> dropping the mutex.

Yeah, correct :-)

- Xiubo


