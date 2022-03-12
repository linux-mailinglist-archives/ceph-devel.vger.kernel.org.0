Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF04D6B6C
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Mar 2022 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiCLAXO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 19:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCLAXN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 19:23:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E258438782
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647044528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z3TlMj/TuDZW5t3SQFhvCGY2ACGmTeod6OwHxDvbuEw=;
        b=DdARLw/+q4uZFODq7j3mC6QT1o76ywnRkvs0hQiaRvttD/WfkauRRQtTAP8uoi+GZFqt/l
        Fu9scGxzL0xPF4m4srMdmqkGVdq4JFtNgPcvUHUN6xsK347U5Z/TqMthAuKR7utqxs2Xti
        jlhnobl3gHMNXjAZnsOA9VjMa/EeOkQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-OWYu3pVNNrKt1tAWFizCpA-1; Fri, 11 Mar 2022 19:22:07 -0500
X-MC-Unique: OWYu3pVNNrKt1tAWFizCpA-1
Received: by mail-pj1-f70.google.com with SMTP id t10-20020a17090a5d8a00b001bed9556134so8876969pji.5
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 16:22:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=z3TlMj/TuDZW5t3SQFhvCGY2ACGmTeod6OwHxDvbuEw=;
        b=po0YCkoIfCiEglVPD+jux1ahnwg8+JfCeQ6sxOWebCUiqKVHOToHXPelLC1jP+JkwU
         hDT3MABQwyps518xnwFh+g7WUBhHcQQFuPoT3XCJTyIyd7mQPMjhubgOrKEM28qUe1bO
         Qi8grry0kfBsqLpqPqEKmqVbpV/d3BcpVC4Os/xDfR88fhvvG6uWPGmA9fQwPmwaHBBi
         Buq0rkVglDonGzuvoPHfZ7bced+KPVJ4gvS7RJCG7ftZyED3qacHpviYtlqtXdZ5rWjm
         BLeLfdlcNZ3LgFRMlEoDA8lRLaZsTefbEhrvFK5XSoyCC8si/M3tfQ1YFy8znVmGMcC7
         yJBA==
X-Gm-Message-State: AOAM531H/YSYeQPDssx1DZt0T8dQ0fyaOz1Q3z6iqfuMe2dTKLumHJGu
        Ie9eCgpKvIHp2OsajHEkpuG41MPpYMwqrlubfDN4kYa8iPzsuvWtU8stnEegEkdI5OEZF1PvX+7
        97Ldz2vcUiI1kHN7Tc01sqoUVNP2sjP0hgakEsTI+yP0g7fMKzSU7Fl+mdOwNxh3+KjD/5l8=
X-Received: by 2002:a17:90b:4ac1:b0:1bf:6d51:1ad9 with SMTP id mh1-20020a17090b4ac100b001bf6d511ad9mr24300762pjb.199.1647044525627;
        Fri, 11 Mar 2022 16:22:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1rDdIX6u2oZtUzmakJs1StvseWMU0fLYup0A4tDmMR04B+fu4WI6HzXL1x4/NocJBsihzDA==
X-Received: by 2002:a17:90b:4ac1:b0:1bf:6d51:1ad9 with SMTP id mh1-20020a17090b4ac100b001bf6d511ad9mr24300711pjb.199.1647044524972;
        Fri, 11 Mar 2022 16:22:04 -0800 (PST)
Received: from [10.72.12.132] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm12452449pfl.140.2022.03.11.16.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 16:22:04 -0800 (PST)
Subject: Re: [PATCH 0/4] ceph: dencrypt the dentry names early and once for
 readdir
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220311104558.157283-1-xiubli@redhat.com>
 <87ee3879zi.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <22503bed-6282-701e-2bf8-19fb5393f259@redhat.com>
Date:   Sat, 12 Mar 2022 08:21:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87ee3879zi.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/12/22 12:02 AM, Luís Henriques wrote:
> Hi Xiubo,
>
> I've started reviewing this patchset but, while running some quick tests,
> I've seen found a bug.  I was testing with fstests, but I can easily
> reproduce it simply using 'src/dirhash_collide', from fstests:
>
> - mount filesystem and create an encrypted directory
>
> - run that application on the encrypted (unlocked) directory:
>      # cd mydir
>      # $FSTESTSDIR/src/dirhash_collide -d -n 10000 .
>
> - umount filesystem and mount it again
>
> - do an 'ls' in 'mydir' and I get:
>
> [  115.807181] ------------[ cut here ]------------
> [  115.807865] WARNING: CPU: 0 PID: 220 at fs/ceph/crypto.c:138 ceph_encode_encrypted_dname+0x1e6/0x240 [ceph]
> [  115.809298] Modules linked in: ceph libceph
> [  115.809881] CPU: 0 PID: 220 Comm: ls Not tainted 5.17.0-rc6+ #91
> [  115.810720] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
> [  115.812298] RIP: 0010:ceph_encode_encrypted_dname+0x1e6/0x240 [ceph]
> [  115.813238] Code: 48 8b 44 24 50 48 89 85 ad 00 00 00 48 8b 44 24 58 48 89 85 b5 00 00 00 e9 2f ff ff ff 48 89 ef e8 6f dd 17 e1 e9 45 ff ff ff <0f> 0b e9 a2 fe ff ff 417
> [  115.815800] RSP: 0018:ffffc90000487bc0 EFLAGS: 00010246
> [  115.816519] RAX: 0000000000000000 RBX: 1ffff92000090f78 RCX: ffffffffa014654e
> [  115.817502] RDX: dffffc0000000000 RSI: ffffc90000487d58 RDI: ffff8880791b3230
> [  115.818466] RBP: ffffc90000487e90 R08: 0000000000000007 R09: ffff8880605d8748
> [  115.819445] R10: fffffbfff05a79b3 R11: 0000000000000001 R12: ffff8880791b2fe8
> [  115.820437] R13: ffff88807f88ae00 R14: ffffc90000487d58 R15: 0000000000000000
> [  115.821424] FS:  00007fe454541800(0000) GS:ffff888060c00000(0000) knlGS:0000000000000000
> [  115.822526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  115.823308] CR2: 00007fe454530058 CR3: 000000000d6a0000 CR4: 00000000000006b0
> [  115.824296] Call Trace:
> [  115.824646]  <TASK>
> [  115.824963]  ? ceph_fscrypt_as_ctx_to_req+0x40/0x40 [ceph]
> [  115.825774]  ? create_object.isra.0+0x34a/0x4b0
> [  115.826418]  ? preempt_count_sub+0x18/0xc0
> [  115.827069]  ? _raw_spin_unlock_irqrestore+0x28/0x40
> [  115.827815]  ceph_readdir+0xe24/0x1fa0 [ceph]
> [  115.828459]  ? preempt_count_sub+0x18/0xc0
> [  115.829028]  ? preempt_count_sub+0x18/0xc0
> [  115.829604]  ? ceph_d_revalidate+0x970/0x970 [ceph]
> [  115.830314]  ? down_write_killable+0xb2/0x110
> [  115.830921]  ? __down_killable+0x200/0x200
> [  115.831488]  iterate_dir+0xe9/0x2a0
> [  115.831995]  __x64_sys_getdents64+0xf2/0x1c0
> [  115.832587]  ? __x64_sys_getdents+0x1c0/0x1c0
> [  115.833203]  ? handle_mm_fault+0x1c3/0x230
> [  115.833778]  ? compat_fillonedir+0x1b0/0x1b0
> [  115.834419]  ? do_user_addr_fault+0x32b/0x940
> [  115.835048]  do_syscall_64+0x43/0x90
> [  115.835575]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> After this, I also see some KASAN NULL pointers, but I assume it's the
> result of the above bug.

Hi Luis,

Thanks for your feedback.

Yesterday I have test this by using both the fsstress and xfstests for 1 
hour, didn't see this call trace.

I will check it.

- XIubo


> Cheers,

