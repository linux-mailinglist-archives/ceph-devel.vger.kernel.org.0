Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D33D8671
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Oct 2019 05:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfJPD2i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 23:28:38 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:35331 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfJPD2i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Oct 2019 23:28:38 -0400
Received: by mail-io1-f41.google.com with SMTP id q10so51992507iop.2
        for <ceph-devel@vger.kernel.org>; Tue, 15 Oct 2019 20:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Xd12I/SMAsw3lAfxu6vz3pvg65sVxj3TEQxltnuLxs=;
        b=g27G156/N1NS4LZgM4mwRHEWTfs9CzkDAuHpObkk5dlySZ8UnqMLkLOhNGh8Hm0CH+
         iOt9vCq7mtmMNpTTCrhYh45W6YtbXlYT6xF5nwtN8LQWrKVU1CRNYw55waSSmG3l9/P1
         CSwua0jZ9LaSArmcH4Io5cEp+YwDHv/iRvV95vVLYU52FJrntzXjjEDAik8xTGZqW8QF
         lbtXMXcRbZ/CqX8gQVHB0DySf6/XhRbu0nSyWLSyekHEMw7F3EA6dBDo9D5yYUhfaygE
         IJt4TuLTMn6ib5ei95S2KcnfPiqHgOciPrXzcY9FevUjEs7Qgj7qWUF4T6R1aFTWTvvm
         uorQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Xd12I/SMAsw3lAfxu6vz3pvg65sVxj3TEQxltnuLxs=;
        b=Lhaw/Ra9poUr15H9l6iTkaa3FLV+zu24Dxq4Z2rUvUuB9mvsiESFYYsU7Pr3TNdUfM
         86nlxSDgr0ByfGwsOFDwIEAORgrLn3rGaArp8X8kxP6Ld8QwVeFgLwwhaIqkve0OEtn+
         S6dUH4uTl3O+/aY5WLx0di76NNSfkksFUDIg+uBm8KmgcA7Hpuqm9GB+jafgGANXcGBM
         /BUBVe0+ozSAim62pJECBfP65Uf/oiBiUsyc6rCTHmFxvAYTauTk6OEQIJO58O+Vf5DV
         VHz60Z44X1jPhY2FDMIJLAYP7l4rqxpkE34gmOLeCBnaumiuKVV39mVFgjCyAfRkN35m
         sXhQ==
X-Gm-Message-State: APjAAAXb8dThmDP8W3aT5cqPI9/VspeTXPZsH2viyAuRabVgSrO5QCOl
        /ixg7sWFWBH7XwvkIINNQxpkO0181sHrXTL5S/4=
X-Google-Smtp-Source: APXvYqzVpp9vzN7eWKnMVbVzyohi6y3DneavkYp/dZGCr5WxYctMa2GIEVkCtQXfibEa2/4TEfmrIQnfpc145JYKRpI=
X-Received: by 2002:a02:cc4e:: with SMTP id i14mr7274190jaq.32.1571196517035;
 Tue, 15 Oct 2019 20:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
In-Reply-To: <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Wed, 16 Oct 2019 11:28:25 +0800
Message-ID: <CAMrPN_Jz2UaBCRuUUfb1-bwPEgvgEk7BJK4kTD35Tmt_ZBXK0w@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Ning Yao <zay11022@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 15 Oct 2019 at 20:15, Ning Yao <zay11022@gmail.com> wrote:
>
> Honggang(Joseph) Yang <eagle.rtlinux@gmail.com> =E4=BA=8E2019=E5=B9=B410=
=E6=9C=8812=E6=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:04=E5=86=99=E9=
=81=93=EF=BC=9A
>>
>> Hi,
>>
>> We implemented a new cache tier mode - local mode. In this mode, an
>> osd is configured to manage two data devices, one is fast device, one
>> is slow device. Hot objects are promoted from slow device to fast
>> device, and demoted from fast device to slow device when they become
>> cold.
>>
>>
>
> I'm quite interesting about this and seems quite promising. But it seems =
objects level tier seems still not efficient enough in the small write scen=
ario (4k ~ 8k based on your fio test result), right?
> Now, in bluestore, it is possbile to implement a fine-grain local tier. i=
t seems bluestore_pextent_t may be allocated from different devices and str=
ategies like extent level hitset to evaluate whether some extents need to d=
emote to slow devices. A promotion or demotion may submit a read with write=
 operations in a transactions, and finished with a onode or blobs flushed i=
nto rocksdb.

Tier local mode offers a more flexible mechanism for the up
layer(rgw/cephfs/rbd) to participate the tier migration work.
As for the performance test result, its highly dependent on the io
pattern and quality of my code :)
>
>> The introduction of tier local mode in detail is
>> https://tracker.ceph.com/issues/42286
>>
>> tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-n=
ew
>>
>> This work is based on ceph v12.2.5. I'm glad to port it to master
>> branch if needed.
>>
>> Any advice and suggestions will be greatly appreciated.
>>
>> thx,
>>
>> Yang Honggang
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io
