Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAE152A0F0
	for <lists+ceph-devel@lfdr.de>; Tue, 17 May 2022 14:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345651AbiEQL75 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 May 2022 07:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345594AbiEQL7r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 May 2022 07:59:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E30194C41B
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 04:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652788785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bky1QCX4iUNRvLfJN4MOMnAL4Kz8bDrwtH7Mk3KIwD4=;
        b=K6zF5zTfVGNKJWO+i8U13FCUrGmmCgZPboWZeFiZUyte5vnzmSyHD4Vzg2YfinIEh1tMti
        SY+iu5nIKBc8zOoEVOgWLbxEkFeMjFwfJKbNB9O0AubP/8S3xJx9OsvIBcRFcbdNwLIgCi
        Ds2uuLUr4ZDpkAOHmcLNh3V61DxizyM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-hHX2I3OEM_OZ3Kz-SGCOZA-1; Tue, 17 May 2022 07:59:43 -0400
X-MC-Unique: hHX2I3OEM_OZ3Kz-SGCOZA-1
Received: by mail-pg1-f200.google.com with SMTP id q17-20020a656851000000b003c66b4c5d54so8787208pgt.6
        for <ceph-devel@vger.kernel.org>; Tue, 17 May 2022 04:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bky1QCX4iUNRvLfJN4MOMnAL4Kz8bDrwtH7Mk3KIwD4=;
        b=halWFSsBDgy0TDv+XbzIjbt5Z1fGX+lhxmv19cIQRnAMpqF+mmHXSZ5htvrjSo+xAH
         cARXviAftMstmE3V03it/yMg/EjFT9w7wudWYUg3P83UH+tNtEzS6E4W/OgrhuCH7B7g
         lIsWbKoTjGHm96vt5oRoBTA1Rl/fWzmFLUh0KhrkQ69ybUphMROLHmdn82HqYLkrqKmS
         5zmU6MTkOfnCiD/BBICIIAUZFhxRHgsklwg/nL65S4XnhY8i5AF5D3DXUfxZAyhVXdim
         Dp4IcUMMbH0xmUIYnXGbuTs6lMmKDvhHYLEvK7h77kYBSPReCPqhHb4YlAyOrTE8qtsk
         HGlg==
X-Gm-Message-State: AOAM533H7wK5PrfHSpSJScVTQ3youEFwLAeEylwfZWvTAJ9fbKKojdO0
        ou5QA+4xBKph2uM/71HnyrpvhJPABziBEdAOeykijpGwinrIKgIDTdW6UOY1L5V7xSGiBz8mUL0
        iLftWh3KuqISw7mifRBAhEA==
X-Received: by 2002:a17:902:864b:b0:15e:f9e0:20ca with SMTP id y11-20020a170902864b00b0015ef9e020camr21879630plt.122.1652788782579;
        Tue, 17 May 2022 04:59:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7NyXpdX9BSQpzfJPwSczWlBe7ODqWrJK9S94Cn5fydFV8bNFIfqDgh6xxvNJ3ZGMTNnNGTw==
X-Received: by 2002:a17:902:864b:b0:15e:f9e0:20ca with SMTP id y11-20020a170902864b00b0015ef9e020camr21879607plt.122.1652788782352;
        Tue, 17 May 2022 04:59:42 -0700 (PDT)
Received: from [10.72.12.136] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z7-20020a170902d54700b0015e8d4eb2e8sm5132142plf.306.2022.05.17.04.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 04:59:41 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] ceph: wait the first reply of inflight
 unlink/rmdir
To:     Jeff Layton <jlayton@kernel.org>, viro@zeniv.linux.org.uk
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, arnd@arndb.de, mcgrof@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220517010316.81483-1-xiubli@redhat.com>
 <20220517010316.81483-3-xiubli@redhat.com>
 <a2d05d80e30831e915e707a48520139500befc2b.camel@kernel.org>
 <bce4ef40-277f-8bc0-6cdb-3435eddddf44@redhat.com>
 <bd2ea8d6467ff8ea98c7bd048fd417aced86e20d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <718ffcfa-d211-23ec-947c-0c9dec33781c@redhat.com>
Date:   Tue, 17 May 2022 19:59:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bd2ea8d6467ff8ea98c7bd048fd417aced86e20d.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/22 7:54 PM, Jeff Layton wrote:
> On Tue, 2022-05-17 at 19:49 +0800, Xiubo Li wrote:
>> On 5/17/22 7:35 PM, Jeff Layton wrote:
>>> On Tue, 2022-05-17 at 09:03 +0800, Xiubo Li wrote:
>>>> In async unlink case the kclient won't wait for the first reply
>>>> from MDS and just drop all the links and unhash the dentry and then
>>>> succeeds immediately.
>>>>
>>>> For any new create/link/rename,etc requests followed by using the
>>>> same file names we must wait for the first reply of the inflight
...
>>> I doubt you need this large a hashtable, particularly given that this is
>>> per-superblock. In most cases, we'll just have a few of these in flight
>>> at a time.
>> A global hashtable ? And set the order to 8 ?
> Per-sb is fine, IMO. 6-8 bits sounds reasonable.

Sure, let's use 8. From my snaptest I can see there had a lot of 
dentries in the hashtable at the same time some times.

-- Xiubo

