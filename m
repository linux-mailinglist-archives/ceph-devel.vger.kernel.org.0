Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8F707D0C
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjERJhl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 May 2023 05:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjERJhh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 May 2023 05:37:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9888E1726
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 02:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684402612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sx268Ym0NlJcfPg9VgsjXfacgYG8r4fO3sFzTC8ebFY=;
        b=BA1Mq9JlChcTuEwVr9cxEafizjf6Gvdm1/cD1OdVSXIwSkcU2G9Sig+GKUJI4Dwz/JpU3s
        5Lk0Lx5pUQ/I4BKs2AvT5vAvMAPChDfkpa2ZLZZSoxVi67KWjTNuvKAobOJGuDJ0FF8oJY
        3mu7MeaS7GL0qPGlZxjxSI1RVqs28/4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-WQwp1HX0O7yb3eTdtHWk4w-1; Thu, 18 May 2023 05:36:51 -0400
X-MC-Unique: WQwp1HX0O7yb3eTdtHWk4w-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ac3606cd9eso12374435ad.2
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 02:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684402610; x=1686994610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sx268Ym0NlJcfPg9VgsjXfacgYG8r4fO3sFzTC8ebFY=;
        b=QBZfu+YQCWS4l5IRWSIBYPROqPktV+zOWGx+9aOzqCYKfkSRc/fsOTy7pXl8k9TZxz
         dyQD2e8Z5oR+KMHo/Zdf9Z5BprgCsS1UwIdM7mzSRWT5L7IU+Uwm9xvAdIyJVdQBPRcv
         SLB91SKwi+rCE7yqdVt47SXHct79CydsbGwMJHPh1d6nDpkLnurHSyq4GV22nbUN8K7b
         v6cdyjBlqtTqEjmSlJMHAQKwyCpzlEcrC37J28ncDNz3gRhJEqrNRzS/u0Ld+mkq7oyC
         JrXKvzPsGk+qiLcX5CDHIppeVw3XKJzHGTV3RLE+T03b3SIt95kLVzUpyoTMv94oSioU
         daJA==
X-Gm-Message-State: AC+VfDzUxV3Iohijfkcpo3ospIoLXeEqIypDlOm+01I02MIv+5BK1gRm
        kGCbxTnU0EUQaGRMTadJhF1JumUO9YfYziVsWZDDGqU6MY/c18fg652DcNPMlMxv67WsokApEX/
        AsZQJ4Ol8Jc3HQaJmxiyOYw==
X-Received: by 2002:a17:902:e847:b0:1a8:ce:afd1 with SMTP id t7-20020a170902e84700b001a800ceafd1mr2244674plg.20.1684402610116;
        Thu, 18 May 2023 02:36:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ726rZSuqYi+wRvIF0K1qdhclbqKDoSuQJ0Yh9Ov+NuOdNlI+/giU/U4Wde7IBv0cBt3z1B+A==
X-Received: by 2002:a17:902:e847:b0:1a8:ce:afd1 with SMTP id t7-20020a170902e84700b001a800ceafd1mr2244659plg.20.1684402609776;
        Thu, 18 May 2023 02:36:49 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ju19-20020a170903429300b001a64c4023aesm965609plb.36.2023.05.18.02.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 02:36:49 -0700 (PDT)
Message-ID: <f1d878b4-a46f-c342-a028-9a2241cb7ee6@redhat.com>
Date:   Thu, 18 May 2023 17:36:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] ceph: force updating the msg pointer in non-split case
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
References: <20230518014723.148327-1-xiubli@redhat.com>
 <CAOi1vP8yHgtX6YZKcOwWE_KFARtHL65SE5ykyKHQfasMnj2t4Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8yHgtX6YZKcOwWE_KFARtHL65SE5ykyKHQfasMnj2t4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/18/23 17:19, Ilya Dryomov wrote:
> On Thu, May 18, 2023 at 3:48 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
>> request may still contain a list of 'split_realms', and we need
>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Frank Schilder <frans@dtu.dk>
>> Reported-by: Frank Schilder <frans@dtu.dk>
>> URL: https://tracker.ceph.com/issues/61200
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Add a detail comment for the code.
>>
>>
>>   fs/ceph/snap.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 0e59e95a96d9..0f00f977c0f0 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -1114,6 +1114,19 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>                                  continue;
>>                          adjust_snap_realm_parent(mdsc, child, realm->ino);
>>                  }
>> +       } else {
>> +               /*
>> +                * In non-SPLIT op case both the 'num_split_inos' and
>> +                * 'num_split_realms' should always be 0 and this will
>> +                * do nothing. But the MDS has one bug that in one of
>> +                * the UPDATE op cases it will pass a 'split_realms'
>> +                * list by mistake, and then will corrupted the snap
>> +                * trace in ceph_update_snap_trace().
>> +                *
>> +                * So we should skip them anyway here.
>> +                */
>> +               p += sizeof(u64) * num_split_inos;
>> +               p += sizeof(u64) * num_split_realms;
>>          }
>>
>>          /*
>> --
>> 2.40.1
>>
> LGTM, staged for 6.4-rc3 with a slightly amended comment.

Sure, thanks.

- Xiubo


> Thanks,
>
>                  Ilya
>

