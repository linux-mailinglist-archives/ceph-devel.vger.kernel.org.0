Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8DC6E3EAA
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 06:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjDQE5h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Apr 2023 00:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjDQE5g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Apr 2023 00:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97BE10D8
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 21:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681707408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m3BnFojWZL/bG/zPigloJEN3ndYrUcDTrtcXiM6ketw=;
        b=Tfkour2C0+F3rHH69b1aCjVz6sNkCG7GUQtd8rwk/Z14EqjYLCFv0Hee79bf9IoYZiz2rK
        zWQH1SRZwRkD0mbVvlA/V4hGbSIFfyXtdnvPAIMOJB+V+vmVGxO7hs5XcP96IwWaeuEDO7
        Yv7DVePAgL2/JngpqhdzhWwHauV5eGY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-EPPUQMFJOHugY3JEXbq0mQ-1; Mon, 17 Apr 2023 00:56:46 -0400
X-MC-Unique: EPPUQMFJOHugY3JEXbq0mQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-51b67183546so246803a12.0
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 21:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681707405; x=1684299405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m3BnFojWZL/bG/zPigloJEN3ndYrUcDTrtcXiM6ketw=;
        b=X00633J6bKa3v0Wp60Gi6q/jYxbMrZPF5e3LVyL2qf5toOenYJtArlVFOb7VWheVnQ
         O/Cp1d46OZtm65WAbypXM0tVS4a7elYZmE1DdjXPh43MeUn9wsh7TY+5l1WJRimch5Xs
         Az+hRo5Ks2ecfhLPEth5FwMArRMg5uhlGpHYUa6B0wf0nAlmhaMySyQmrRDrSHJUiYQy
         WLviwT5z9E9WkVlMwFGtwqaJllHevoS+cRbueevCs9I4OiDgYCJNK0u6eFfLwBgliIWv
         dWAxtQKHmub99XDMQCL1KPD0uQ9S0YS7J5Gf+uyrgJGCteWiYolZG6RLh5tbQdciVfET
         4XBQ==
X-Gm-Message-State: AAQBX9fKSND2xt+nYoH08YdB71ooKqLgLF2douK41FlicVD5xEQ59K0H
        R5TRtMw4IdYoS600JNSt3OaiB4+zz/A48Lt4MiMMLZuy0JeI0o2eWY8bjxHm43BqgK353szb8ID
        b1utmREmhWfyEBvefj9wqrgtaKn9GPEByUrE=
X-Received: by 2002:a05:6a00:17a9:b0:63b:8b47:453c with SMTP id s41-20020a056a0017a900b0063b8b47453cmr4698274pfg.1.1681707405382;
        Sun, 16 Apr 2023 21:56:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZWVIyQhNc125Br02ERP6RgBnPbaIr0QiV5VeUubxkxkvksUIPHl2cGfx/uI1APHkaRJSGbXA==
X-Received: by 2002:a05:6a00:17a9:b0:63b:8b47:453c with SMTP id s41-20020a056a0017a900b0063b8b47453cmr4698266pfg.1.1681707405127;
        Sun, 16 Apr 2023 21:56:45 -0700 (PDT)
Received: from [10.72.12.181] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y1-20020aa78541000000b00638b13ee6a7sm6648061pfn.25.2023.04.16.21.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Apr 2023 21:56:44 -0700 (PDT)
Message-ID: <34ad8dc4-6bf9-15b4-3c04-c43165ecb229@redhat.com>
Date:   Mon, 17 Apr 2023 12:56:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] common/rc: skip ceph when atime is required
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20230417024134.30560-1-xiubli@redhat.com>
 <20230417041752.lryihlt7atnljfzo@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230417041752.lryihlt7atnljfzo@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/17/23 12:17, Zorro Lang wrote:
> On Mon, Apr 17, 2023 at 10:41:34AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Ceph won't maintain the atime, so just skip the tests when the atime
>> is required.
>>
>> URL: https://tracker.ceph.com/issues/53844
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   common/rc | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 90749343..3238842e 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -3999,6 +3999,9 @@ _require_atime()
>>   	nfs|cifs|virtiofs)
>>   		_notrun "atime related mount options have no effect on $FSTYP"
>>   		;;
>> +	ceph)
>> +                _notrun "atime not maintained by $FSTYP"
> Make sense to me. I'll change this line a bit when I merge it, to keep the line
> aligned (with above).
>
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Sure, thanks Zorro.

- Xiubo


> Thanks,
> Zorro
>
>> +		;;
>>   	esac
>>   
>>   }
>> -- 
>> 2.39.1
>>

