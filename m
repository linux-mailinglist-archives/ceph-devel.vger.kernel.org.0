Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56F6FC081
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjEIHdD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 03:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjEIHdB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 03:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3ADA5D8
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 00:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683617534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y9DylKCX3NuyEcWs7W7MJ1BHhFWKgKXojvHI7ub2JKs=;
        b=ICVlbQffh/QZOHnsWAxx4QW4RQ9TV8U2zTAMBmfDDibVcWJxweoan95j+/Pp4xAH0PrmnD
        FTi/y73N0XHKFagjz/s9tWI/98OIP9WiyFwnpj6mxZSgyBcoBIaJ3eypp9408lhjgAOLJG
        IzcGDY/XtvlahI6YyqhIYIP7YUGgHUU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-0s-jQHG9Pp-uMw3ggZftYQ-1; Tue, 09 May 2023 03:32:13 -0400
X-MC-Unique: 0s-jQHG9Pp-uMw3ggZftYQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-24e00b8cc73so3082333a91.0
        for <ceph-devel@vger.kernel.org>; Tue, 09 May 2023 00:32:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683617532; x=1686209532;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9DylKCX3NuyEcWs7W7MJ1BHhFWKgKXojvHI7ub2JKs=;
        b=T/0M6ARr/3OyPP+YeA759je5Gl5qF1ksGc0318Vks7WnYVp6atPg8xt47bdMMVHQbL
         srBfgJnFzs2ADooK0L0ZAv5an3E4PwwxBbY+62q2degtkaaPkl/ebcOEVGBDBJqwFsX8
         dzzyeXb7hpRXfFpJepBvO7+wUiADPZUYylYZ2IjiFSQPSj66OyvO63DWuKWCI50hrrh1
         N3ltDvPNHV/bfh7ljGq4cs4pp201duxXBhYeGz6vCSmZ6hnOFdDn90liRMux+ONpjxWa
         /vCU2oHzDe9pvUQI4C7X702vJgKzwu0g3ulpsn+C6iawUmSGm5KQoQfzi2H84dy69bVP
         C4OQ==
X-Gm-Message-State: AC+VfDwN/j2tU6vT2h2sVo1/ceKQHQxvp8U0q4cDCUca471k2xvWXxaP
        pYA0DCArMLjUcOgIgO9FPS31J30S9bC1dJCLvIScMXRR+h7zi8j8eAhqVuC+CGW9aXMzo6n++a4
        iEg22NBzJ0u8+uL0Wxss5CQ==
X-Received: by 2002:a17:902:6545:b0:1a9:2c70:e1eb with SMTP id d5-20020a170902654500b001a92c70e1ebmr12786073pln.36.1683617532602;
        Tue, 09 May 2023 00:32:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ67rbv61soZ0GmjZp9g09Tc7COtrtzKKxexlskMZxtsM3UDkOaTNu5VHmIgkZNPbSukcAFdPA==
X-Received: by 2002:a17:902:6545:b0:1a9:2c70:e1eb with SMTP id d5-20020a170902654500b001a92c70e1ebmr12786060pln.36.1683617532239;
        Tue, 09 May 2023 00:32:12 -0700 (PDT)
Received: from [10.72.12.156] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z20-20020a1709028f9400b001ab1cdb41d6sm786148plo.235.2023.05.09.00.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 00:32:11 -0700 (PDT)
Message-ID: <16471d19-5228-a3b7-cb08-86c94535ea3b@redhat.com>
Date:   Tue, 9 May 2023 15:32:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] Ceph updates for 6.4-rc1
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org
References: <20230504182810.165185-1-idryomov@gmail.com>
 <87wn1nm2bu.fsf@brahms.olymp>
 <CAOi1vP_eqNTrQMX1jC-jXJTKZKb=GifQtFfzgrsMXQffBgQuYw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_eqNTrQMX1jC-jXJTKZKb=GifQtFfzgrsMXQffBgQuYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/6/23 02:59, Ilya Dryomov wrote:
> On Fri, May 5, 2023 at 1:42 PM Luís Henriques <lhenriques@suse.de> wrote:
>>
>> [re-arranged CC list]
>>
>> Ilya Dryomov <idryomov@gmail.com> writes:
>>
>>> Hi Linus,
>>>
>>> The following changes since commit 457391b0380335d5e9a5babdec90ac53928b23b4:
>>>
>>>    Linux 6.3 (2023-04-23 12:02:52 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>    https://github.com/ceph/ceph-client.git tags/ceph-for-6.4-rc1
>>>
>>> for you to fetch changes up to db2993a423e3fd0e4878f4d3ac66fe717f5f072e:
>>>
>>>    ceph: reorder fields in 'struct ceph_snapid_map' (2023-04-30 12:37:28 +0200)
>>>
>>> ----------------------------------------------------------------
>>> A few filesystem improvements, with a rather nasty use-after-free fix
>>> from Xiubo intended for stable.
>> Thank you, Ilya.  It's unfortunate that fscrypt support misses yet another
>> merge window, but I guess there are still a few loose ends.
>>
>> Is there a public list of issues (kernel or ceph proper) still to be
>> sorted out before this feature gets merged?  Or is this just a lack of
>> confidence on the implementation stability?
> Hi Luís,
>
> When fscrypt work got supposedly finalized it was already pretty late
> in the cycle and it just didn't help that upon pulling it I encountered
> a subtly broken patch which was NACKed before ("libceph: defer removing
> the req from osdc just after req->r_callback")

We still need this patch or a new patch to fix this.

Another patch will only fix the mds request case, but not the osd 
request case.

thanks

>   and also that "optionally
> bypass content encryption" leftover.  It got addressed but too late for
> such a large change to be staged for 6.4 merge window.
>
> I would encourage everyone to make another pass over the entire series
> to make sure that there is nothing eyebrows-raising left there and that
> it really feels solid.
>
> Thanks,
>
>                  Ilya
>

