Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8EAB7D4
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 14:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733199AbfIFMIQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 6 Sep 2019 08:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732863AbfIFMIQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 08:08:16 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A000C369DA
        for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2019 12:08:15 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id n135so6140593qka.13
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2019 05:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/TbTAxwKkrmySyjA0AMH5SzmyU83d4Z4foYjZ7s5z6Y=;
        b=oMxHjWQW/47BHybxUY7Dw+1ezKu9036VzBcCgGe2nqp50BNqmsX5ZrVdihVj/rFeOf
         TLWmCWPCKdCQkXlh0v2H/QoeFs1uBmFJ03cq8NO9Eq7TCCtGsAoleuMXJmKHV5uXb0+g
         HAlwCS8Wpgazx5uw49z3mxdMGHt9YD2SNupV8i8cYe1TqgFrnfL1x4KpaPZuLCi0TLLC
         NHLZh42ACJgrH5WNt6NqJvygHZwoWP83VMX6CIwh/QRiGG57emFwn0VKAvbAQVqhxpex
         XKIXlrk9hGYkaLAR9SBj8VAtWoJHvfowrxgozIswDlAWyJnLt2YbagOnDS4/i3rkM/dG
         0XGQ==
X-Gm-Message-State: APjAAAVfnbXLNB9T8I5wwn+xW9NME7bm/dPSjbYFZdYuGE1e1uVJagDI
        NsXBpGiEG519NmQldsqYOK84/ypY0VJd+gD5PP8UgeJYc8b2KON8YFWAHpiUj0g8A+mYfvmDp6C
        41rL2vqs3tAPSU97c8QesBt+nSD0+1QuAuGdQuQ==
X-Received: by 2002:ac8:4548:: with SMTP id z8mr8342352qtn.258.1567771694428;
        Fri, 06 Sep 2019 05:08:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqywKC6C4Kw/HDYg8ajr7l1/jBATtqGMrPcRUkwjRAqRHXqs+sPuefpGiq2oEjv5JaeRb/1AezJDVDDVI1mpKbQ=
X-Received: by 2002:ac8:4548:: with SMTP id z8mr8342326qtn.258.1567771694241;
 Fri, 06 Sep 2019 05:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
 <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com>
 <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com>
 <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
 <CAC-Np1w45EGTW07ovfrK_sWNg5JNuMkwbs7kxcfBxr=98n6xsQ@mail.gmail.com> <7104c259-7874-3af7-f2b8-85b6066ec878@m-privacy.de>
In-Reply-To: <7104c259-7874-3af7-f2b8-85b6066ec878@m-privacy.de>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Fri, 6 Sep 2019 08:08:03 -0400
Message-ID: <CAC-Np1wdR+kFRnrNKhTyKphznGDu56i9P4mKfxEfNJYV9sWERg@mail.gmail.com>
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Amon Ott <a.ott@m-privacy.de>
Cc:     Sasha Litvak <alexander.v.litvak@gmail.com>,
        Paul Emmerich <paul.emmerich@croit.io>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thank you all for confirming the fix, I'll follow up today with a
proper pull request, but I can't tell when we can get a release once
it lands in the various release branches.

On Fri, Sep 6, 2019 at 4:23 AM Amon Ott <a.ott@m-privacy.de> wrote:
>
> Am 05.09.19 um 13:56 schrieb Alfredo Deza:
> > While we try to fix this, in the meantime the only workaround is not
> > to redirect stderr. This is far from ideal if you require redirection,
> > but so far is the only workaround to avoid this problem.
>
> This bug also broke our ceph-deploy based installation scripts, even
> with a single OSD. I can confirm that the fix you posted makes
> ceph-deploy work for us again.
>
> Amon Ott
> --
> Dr. Amon Ott
> m-privacy GmbH           Tel: +49 30 24342334
> Werner-Voß-Damm 62       Fax: +49 30 99296856
> 12101 Berlin             http://www.m-privacy.de
>
> Amtsgericht Charlottenburg, HRB 84946
>
> Geschäftsführer:
>  Dipl.-Kfm. Holger Maczkowsky,
>  Roman Maczkowsky
>
> GnuPG-Key-ID: 0x2DD3A649
>
