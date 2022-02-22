Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860714BEE80
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 02:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiBVAYG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Feb 2022 19:24:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiBVAYF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Feb 2022 19:24:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E4E82AFE
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 16:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645489417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akHBZE/+AmFcHVxuto43YDYtC8jEQC4yWVGjirQk9DE=;
        b=gtep1vRu0BvtzsM4qKwfmpY/0B1gGmhOic2lqJgv5GmhiuqRsDDv8TRP3hlqgF7ugNwpzl
        qPIUCI05Cu9la2l3AbJI+PVuF5WO8BeAqxDl2djoG0xFXX1EsRFzwvnVEfGhjMx2j4nTpy
        fziaGqHjVrfjxb1Vl/Ta2ja5lqlMQng=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-1MpkjQWwOsGJNhZZW0hEEg-1; Mon, 21 Feb 2022 19:23:36 -0500
X-MC-Unique: 1MpkjQWwOsGJNhZZW0hEEg-1
Received: by mail-pj1-f71.google.com with SMTP id c14-20020a17090a8d0e00b001bc72e5c3ecso134076pjo.3
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 16:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=akHBZE/+AmFcHVxuto43YDYtC8jEQC4yWVGjirQk9DE=;
        b=pJIOJDzAk9b1hI8bXSvyoVJbAxZWXrD0SKznmq9dPIS31KIX8U9EKDaSqN5ZXNw2Io
         DdYnVtLQp31EFnISjcnOiBODsuiBUinDmrPsmuHUe/FHV8UOUUYVJnp0phVHoWNZ25KQ
         oC/XHZ7QLAjZDqC5n8UYvbL+y3MLhaMXljuWJoxjd8pYLI4eJfIYgT+qFRS4Y3ooDYRR
         xqApTXb8vcXEwu/BlLAbsgXjNFiZe42SWMQTtZAb+QYUQ7/Td54ZQN8bQgUeuNdAgslh
         B8/5U6wyLmF0TVQhEVbDcLkmLy5STKiH83RFXtPFRTMC3yGzxvsceaG8te6AwcQp4rp1
         JYSw==
X-Gm-Message-State: AOAM531Yf9WTPToTuIYWcNdZjNbYjJk1kRCQpasioVDS38VDYTKEs1by
        Xe6IsOBrSnUPJvzxf+6NCp0ZakrPCd0jDKWHd0V/acNxvqVM7GwQFuf0K2oFFBfS5lGBbFkvtzG
        xYkQq7m+CtsfSMks89xaU89U+SRKYQW7TN3ghXLPfBk8zaEIqwSk7OJc+tg/L7WA5ZPllSD8=
X-Received: by 2002:a17:90a:7845:b0:1b9:159c:148e with SMTP id y5-20020a17090a784500b001b9159c148emr1401625pjl.136.1645489415051;
        Mon, 21 Feb 2022 16:23:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgJMTXqsdRrH7WTk8bmdh2miY08tm3yWjnT4BbnP5kGHLEwy5l/9O2+WXfe3H13wcaTme5VQ==
X-Received: by 2002:a17:90a:7845:b0:1b9:159c:148e with SMTP id y5-20020a17090a784500b001b9159c148emr1401595pjl.136.1645489414670;
        Mon, 21 Feb 2022 16:23:34 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s2sm14643461pfk.3.2022.02.21.16.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 16:23:34 -0800 (PST)
Subject: Re: [PATCH v3] ceph: do not update snapshot context when there is no
 new snapshot
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220219062833.30192-1-xiubli@redhat.com>
 <87y224xjaf.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f3dcaf0e-705e-10ad-aa89-b92c765dfdbd@redhat.com>
Date:   Tue, 22 Feb 2022 08:23:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87y224xjaf.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/22/22 12:43 AM, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We will only track the uppest parent snapshot realm from which we
>> need to rebuild the snapshot contexts _downward_ in hierarchy. For
>> all the others having no new snapshot we will do nothing.
>>
>> This fix will avoid calling ceph_queue_cap_snap() on some inodes
>> inappropriately. For example, with the code in mainline, suppose there
>> are 2 directory hierarchies (with 6 directories total), like this:
>>
>> /dir_X1/dir_X2/dir_X3/
>> /dir_Y1/dir_Y2/dir_Y3/
>>
>> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
>> root snapshot under /.snap/root_snap. Every time we make snapshots under
>> /dir_Y1/..., the kclient will always try to rebuild the snap context for
>> snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
>> and dir_Y3, which makes no sense.
>>
>> That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
>> creating a new snapshot under /dir_Y1/... the new seq will be 4, and
>> the mds will send the kclient a snapshot backtrace in _downward_
>> order: seqs 4, 3.
>>
>> When ceph_update_snap_trace() is called, it will always rebuild the from
>> the last realm, that's the root_snap. So later when rebuilding the snap
>> context, the current logic will always cause it to rebuild the snap_X2
>> realm and then try to queue cap snaps for all the inodes related in that
>> realm, even though it's not necessary.
>>
>> This is accompanied by a lot of these sorts of dout messages:
>>
>>      "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>>
>> Fix the logic to avoid this situation.
>>
>> Also, the 'invalidate' word is not precise here. In actuality, it will
>> cause a rebuild of the existing snapshot contexts or just build
>> non-existant ones. Rename it to 'rebuild_snapcs'.
>>
>> URL: https://tracker.ceph.com/issues/44100
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>
>>
>>
>> V3:
>> - Fixed the crash issue reproduced by Luís.
> Thanks, I can confirm I'm no longer seeing this issue.

Cool, thanks Luis.

- Xiubo

>
> Cheers,

