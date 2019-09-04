Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6821FA9765
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Sep 2019 01:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfIDXzF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 4 Sep 2019 19:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIDXzF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 19:55:05 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F39907EBB1
        for <ceph-devel@vger.kernel.org>; Wed,  4 Sep 2019 23:55:04 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id u7so541438qtg.7
        for <ceph-devel@vger.kernel.org>; Wed, 04 Sep 2019 16:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q8RTecrWhH02xwCzdkPD8qm+wc9+uLu9iupC/g7Ntso=;
        b=nOR4dq/jnpAJhlno/8cS/llLdV/jEFE+pOvqzw+oQJvqp4smpSxhB0jp+f/aqxnnPv
         4pEV/PVe1gA5G1p+vFAh40mZgPLMoOyNMbqhthk+3SovvE0LcW3vrn011MvmOnMPB6+J
         1Czlau2p8vmLU3c2PGq54KAwaw3xH5vi6OFNa6rJYe42o+ptoIaEU3YAq8vqOs/UWfRg
         4Ie9eTSiSFrvyq2L5P+sf9u3hSLHHU8IvDIbsDf8pH8sje1W6lOTlTup65UYuUvoLK/2
         Dvt1fFa84hjwU4VsF5ac5Kl+6RBwbaM9tvm/7VNZzxb5ibEEeQV7RDJ27BEYRKlhYEJb
         sC7Q==
X-Gm-Message-State: APjAAAUP5FWip9hjWH16n/xXVV6BMM65bZB0Dzvy3qlXX4MvCY1zVcQF
        j49neFExZUKvqLru8tMt3fxPOC/OJ0iNT83eKXDM6r0b2q82sZi4Nih1TUKzWaKpX3sQ3q/tv2a
        4qmwk2xWwUYlZsEaCg5y40IA96I+GXHY9dN1OmQ==
X-Received: by 2002:a0c:face:: with SMTP id p14mr79389qvo.190.1567641304149;
        Wed, 04 Sep 2019 16:55:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6FdpVmwOWqMkEqLg/qiaquBQyKwK1yfTJEYLmbdsXuu/fkFTTb6GqLGO+W3v/9mIDm3HTYf1Q1PBPeiveiYs=
X-Received: by 2002:a0c:face:: with SMTP id p14mr79380qvo.190.1567641303825;
 Wed, 04 Sep 2019 16:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
 <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com> <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com>
In-Reply-To: <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Wed, 4 Sep 2019 19:54:52 -0400
Message-ID: <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Paul Emmerich <paul.emmerich@croit.io>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 4, 2019 at 6:35 PM Sasha Litvak
<alexander.v.litvak@gmail.com> wrote:
>
> How do you fix it?  Or you wait till 14.2.4?

This is a high priority for me, I will provide a fix as soon as
possible and hopefully a workaround.

>
> On Wed, Sep 4, 2019, 3:38 PM Alfredo Deza <adeza@redhat.com> wrote:
>>
>> On Wed, Sep 4, 2019 at 4:01 PM Paul Emmerich <paul.emmerich@croit.io> wrote:
>> >
>> > Hi,
>> >
>> > see https://tracker.ceph.com/issues/41660
>> >
>> > ceph-volume lvm activate --all fails on the second OSD when stderr is
>> > not a terminal.
>> > Reproducible on different servers, so there's nothing weird about a
>> > particular disk.
>> >
>> > Any idea where/how this is happening?
>>
>> That looks very odd, haven't seen it other than a unit test we have
>> that fails in some machines. I was just investigating that today.
>>
>> Is it possible that the locale is set to something that is not
>> en_US.UTF-8 ? I was able to replicate some failures with LC_ALL=C
>>
>> Another thing I would try is to enable debug (or show/paste the
>> traceback) so that tracebacks are immediately available in the output:
>>
>> CEPH_VOLUME_DEBUG=1 ceph-volume lvm activate --all
>>
>> I'll follow up in the tracker ticket
>> >
>> > This makes 14.2.3 unusable for us as we need to re-activate all OSDs
>> > after reboots because we don't have a persistent system disk.
>> >
>> >
>> > Paul
>> >
>> > --
>> > Paul Emmerich
>> >
>> > Looking for help with your Ceph cluster? Contact us at https://croit.io
>> >
>> > croit GmbH
>> > Freseniusstr. 31h
>> > 81247 München
>> > www.croit.io
>> > Tel: +49 89 1896585 90
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io
