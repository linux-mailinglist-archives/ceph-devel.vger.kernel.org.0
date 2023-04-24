Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5D6ECBF5
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Apr 2023 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDXM0K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Apr 2023 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDXM0I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Apr 2023 08:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAAD120
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 05:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682339123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6XTMoOHO9KcAmfwEnt3XdoaloTP6hAfrm9N0F+e74s=;
        b=JvDEd7Gx2uhDX3JVLL+TTCllHmkbAxgKxJvmD1XSrx28lxKTEhwzP41qFDZq8cdhUdI5sN
        NjCgyrKxb15RfGITqCAyG3d/5Ezt68I9PpMIaB1kyUZiURD4KWbrFviSzAITxNPvs0lbYf
        bjSrIzGcgu9Anqa8Idvrr1eZPpk+rJY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-8CiEOscQOMmGepqeyYPpfA-1; Mon, 24 Apr 2023 08:25:22 -0400
X-MC-Unique: 8CiEOscQOMmGepqeyYPpfA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-63b57ad54a1so3108836b3a.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 05:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682339121; x=1684931121;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6XTMoOHO9KcAmfwEnt3XdoaloTP6hAfrm9N0F+e74s=;
        b=F/1t8ipyoJZ3vHhOjthD8NOPq8P6Th90J0u2k2Z6cfUYRiC0RStP7znAvxymVOY1UC
         MSiiqxpAHIq52JP9AkPFdHnqynXiCUN93IyZKL94HD+fYA6D+38jZZ3ipmbN8TXvstt7
         zyUHplvrJcZ1J20QvFpz+wV5bxLXE2lRUcdyaAEg6JI0Z5cRltHFLMo90aLk+muKeSZE
         vbdTWVpWBBR/FiQnoWo+hNf/PbEEV3kIjnMMtptElixvCov+KPiqarW1QQYyPbFXcKck
         qdaGZ3cFh2seRLa9Y2XSJsWk7Q8z32pA549n8uAVqk7LehsO+7rA9cEyeIJ2qDBlQZcc
         q4wg==
X-Gm-Message-State: AAQBX9ez5k1NHUHdgvZcnDCIqGEBvm/7BwMzlqGpwO+Uwyc2QC4mnMQc
        bIT2Jq0nfAA6un6lq44gD5ePQoOKKvTIesjzQBS3zboNLGX1xhoQeRcn8zI81WCzzpOs8f5LnYz
        F/gUsU+F7BACHiM3cxBI58w==
X-Received: by 2002:a05:6a00:2e0e:b0:63f:1037:cc24 with SMTP id fc14-20020a056a002e0e00b0063f1037cc24mr17455268pfb.32.1682339121000;
        Mon, 24 Apr 2023 05:25:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350aLqNWcWfmZ/G+zwyHbq6yaCyqV+7/J73Gl2tUsBzgdjdEdEnk0ZF9RjyBkKsEyou5kHVvmBw==
X-Received: by 2002:a05:6a00:2e0e:b0:63f:1037:cc24 with SMTP id fc14-20020a056a002e0e00b0063f1037cc24mr17455243pfb.32.1682339120648;
        Mon, 24 Apr 2023 05:25:20 -0700 (PDT)
Received: from [10.72.12.97] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 2-20020a621802000000b0063d24d5f9b6sm7359472pfy.210.2023.04.24.05.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 05:25:20 -0700 (PDT)
Message-ID: <eb37a1c5-21cc-78ed-3334-cae7d8bc73ff@redhat.com>
Date:   Mon, 24 Apr 2023 20:25:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: =?UTF-8?Q?Re=3a_How_to_control_omap_capacity=ef=bc=9f?=
Content-Language: en-US
To:     WeiGuo Ren <rwg1335252904@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <CAPy+zYVpqE6T0V=7Sq4TdaziF+Azgph00FyJ8W+tARBb57Vo0A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAPy+zYVpqE6T0V=7Sq4TdaziF+Azgph00FyJ8W+tARBb57Vo0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi WeiGuo,

I think you should get help from ceph-users@ceph.io instead, this mail 
list is for kernel ceph only.

Thanks

On 4/24/23 19:49, WeiGuo Ren wrote:
> I have two osds. these  osd are used to rgw index pool. After a lot of
> stress tests, these two osds were written to 99.90%. The full ratio
> (95%) did not take effect? I don't know much. Could it be that if the
> osd of omap is fully stored, it cannot be limited by the full ratio?
> ALSO I use ceph-bluestore-tool to expand it . Before I add a partition
> . But i failed, I dont know why.
>

