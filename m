Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE56448100
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhKHON1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234543AbhKHON1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 09:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636380642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nhe1MhuYCEixvXULt/7tdzrg+FP6jnP4TUWmvDNe/0=;
        b=BCZoEclkrbaK+AfrbVjTCWuHRk0+OOx/EIEGL3hgHznwFf9ZlVRqH0Jd779TREcGKPfip3
        iQrYFrhIWWl7FvR3hpu8iLjSWAtphXC6MX355F365eW/P5n1dDqnfZNfdDS29uXk+4kjpa
        K31pL77tP9NX8y6BFH/pMASmnuSPDpc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-SQEmBudmOwmskpIJv7jBNw-1; Mon, 08 Nov 2021 09:10:41 -0500
X-MC-Unique: SQEmBudmOwmskpIJv7jBNw-1
Received: by mail-pj1-f69.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so7054088pjz.8
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 06:10:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/nhe1MhuYCEixvXULt/7tdzrg+FP6jnP4TUWmvDNe/0=;
        b=lZT3lWRZcV7fKg3GKgmZ3ui/pjFpu5Xjn+GsxI7oIeXMiZXvJJL9rXFpfK+I1xHmfl
         R2ZkvFPEZRq/YI/8pse2PqIKPM3xCfPuyPTU21pmaLYFdcQdFEG0v1UclPz8N9i/BM3D
         nArLfsw60mgWoKKewb8wP08yxRgY0Au0qkAqpSfLOD6FXEVAAUrhqaKdbFgpTsZU6Kf7
         lADRuHm3J3F3VovZQhsrj8Mb6IeiD+VipriSi6alXay1IdUmLz67mjz6mtMA+SiK6VJX
         Xa7+KxGAyHTHYx2AJKm1KA3RXys+u/B33yGHuMLwXl+NgRWrblK4iPEK77x/EEIjGV9l
         MWuA==
X-Gm-Message-State: AOAM530e/HmrlPLIk68vpL5B2+BVWILlYo5PABMr1VVQwxskHNPZh0mz
        sUqhREgVqiXTUFq0Fr4nkvrlPfVqRARm0aTN41lZ/kmJIVMRur7sh3vh05c+uxE/rt4HV0/ppaO
        +A4bOE/4hOSJWL7ZDQNsu6pE9caZX0X3KL1iPfWxfkRwl9Q/MAgXikhCicevuNPlbKxhyL5Y=
X-Received: by 2002:a05:6a00:179a:b0:49f:a821:8233 with SMTP id s26-20020a056a00179a00b0049fa8218233mr21139250pfg.66.1636380639078;
        Mon, 08 Nov 2021 06:10:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMe2bE7EccMTuhKW6RAX/b8wy6IkoeH+ITZ0o2NsRfc1WiE+iGa/3fDeVWw3KWYE/ojofyvQ==
X-Received: by 2002:a05:6a00:179a:b0:49f:a821:8233 with SMTP id s26-20020a056a00179a00b0049fa8218233mr21139210pfg.66.1636380638772;
        Mon, 08 Nov 2021 06:10:38 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm16725569pfj.55.2021.11.08.06.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:10:38 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
Date:   Mon, 8 Nov 2021 22:10:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211108135012.79941-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

After this fixing, there still has one bug and I am still looking at it:

[root@lxbceph1 xfstests]# ./check generic/075
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+

generic/075     [failed, exit status 1] - output mismatch (see 
/mnt/kcephfs/xfstests/results//generic/075.out.bad)
     --- tests/generic/075.out    2021-11-08 20:54:07.456980801 +0800
     +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08 
21:20:49.741906997 +0800
     @@ -12,7 +12,4 @@
      -----------------------------------------------
      fsx.2 : -d -N numops -l filelen -S 0
      -----------------------------------------------
     -
     ------------------------------------------------
     -fsx.3 : -d -N numops -l filelen -S 0 -x
     ------------------------------------------------
     ...
     (Run 'diff -u tests/generic/075.out 
/mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the entire diff)
Ran: generic/075
Failures: generic/075
Failed 1 of 1 tests


I checked the result outputs, it seems when truncating the size to a 
smaller sizeA and then to a bigger sizeB again, in theory those contents 
between sizeA and sizeB should be zeroed, but it didn't.

The last block updating is correct.

Any idea ?

Thanks.


On 11/8/21 9:50 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Hi Jeff,
>
> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
>
> Thanks.
>
> Xiubo Li (2):
>    ceph: fix possible crash and data corrupt bugs
>    ceph: there is no need to round up the sizes when new size is 0
>
>   fs/ceph/inode.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>

