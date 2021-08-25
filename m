Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E7B3F6CA5
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 02:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhHYAfK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Aug 2021 20:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAfK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Aug 2021 20:35:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741F7C061757
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 17:34:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so3561272pjs.3
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 17:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=YgKwPyA6p36Qho6zRZdfB9C13LcWagQDxbFTpSuYDjo=;
        b=GAeh7QbFnXVfm9FQSw1EyAklLRMMmCCd4GvGKwqCG8KMfNaYulHwcepuI1MquhoOg4
         7ox9uCoQyN3rRFR1IAM3oQaiJ0fEnHP6Xn/SacsVa28aKB/GOiG/AMS0Jb5AaDO5wOC+
         tnCyfINUDzJyYlSORSQINmI1XtkoYuSJuYjO4JoIEfZnf/vfOm0JWRafXhoAy0eOaWNr
         HDPJWj7LzLRZDeteCnLXDItpm5MzEyxjOCfhbCsIVneG4eTSeJ6Pdn9Gw6AaA8UDHrCn
         5CVrBuxTSdc+SLxJVokhzGE+CBDFcZuwDCWJKFnmROcsIiLP7jURHjBAfoJgOeDHAF1y
         y4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=YgKwPyA6p36Qho6zRZdfB9C13LcWagQDxbFTpSuYDjo=;
        b=FiljAIPMDj6+YY6Xd6MNE7sYKJXOkA7R1DGhkNNYigmjMHo7n0/rUhTqGeSZwfCb3L
         JACL3H6i0l/CSCHvXFeHS7LtF0RUVVxedfMvVQg7V+l1nY4LaIxJKr+GEj/rHI2jI6rs
         yQXx7zDTzO9W14tPgNIYaGGtBrMsShwFYvHXoLFH+4PSSvRPAA19R1Q7PdofwQeF/c2p
         weY4mfVFAdowcJXGRrxEgnK9PMGAZpixJUig2k/QJvbnOLNYJugEbyufESlRG6LB4Zea
         kKW6Q57uJHizBi08u9uloAYBWXc3i4s6WTSLLaeJAIu64BY9e6X7/d3fN5KygG7yFkc7
         /D+A==
X-Gm-Message-State: AOAM5331aK2zfwHPZuLI79O2D+wC2w1caOvxM2pMBFVhppjjxvcpmTlT
        zrIL14b+4Ycsv6Qkb0hj92ULB3idAI7Ok+crcS4=
X-Google-Smtp-Source: ABdhPJzjsIeXZagIJL+S6TDSq+OLU0Rmo9BoKC7bm9i3OWSAnhD742Z1d9o3tkjRBgl2DsTc3haTjvkchJRPawguSqo=
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr7499040pjo.231.1629851664602;
 Tue, 24 Aug 2021 17:34:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:6049:b0:53:1687:3016 with HTTP; Tue, 24 Aug 2021
 17:34:24 -0700 (PDT)
Reply-To: compaorekone34@gmail.com
From:   Kone Compaore <abbttnb001@gmail.com>
Date:   Tue, 24 Aug 2021 17:34:24 -0700
Message-ID: <CA+d4EbPx-GrhL61LjL0nR=QZOHHzDzXdPkg9aANAE-WcuDUGRQ@mail.gmail.com>
Subject: Greetings from Kone
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Greetings to you and your family.

My name is Mr. Kone Compaore, the auditing general with the bank,
Africa Develop bank (ADB) Ouagadougou, Burkina Faso, in West Africa. I
am contacting you to seek our honesty and sincere cooperation in
confidential manner to transfer the sum of 10.5 (Ten million five
hundred thousand Dollars) to your existing or new bank account.

This money belongs to one of our bank client, a Libyan oil exporter
who was working with the former Libyan government; I learn t that he
was killed by the revolutionary forces since October 2011. Our bank is
planning to transfer this entire fund into the government public
treasury as unclaimed fund if nobody comes to claim the money from our
bank after four years without account activities .

We did not know each other before, but due to the fact that the
deceased is a foreigner, the bank will welcome any claim from a
foreigner without any suspect, that is why I decided to look for
someone whim I can trust to come and claim the fund from our bank.

I will endorse your name in the deceased client file here in my office
which will indicate to that the deceased is your legal joint account
business partner or family member next of kin to the deceased and
officially the bank will transfer the fund to your bank account within
seven working days in accordance to our banking inheritance rules and
fund claim regulation.

I will share 40% for you and 60% for me after the fund is transferred
to your bank account, we need to act fast to complete this transaction
within seven days. I will come to your country to collect my share
after the fund is transferred to your bank account in your country. I
hope that you will not disappoint me after the fund is transferred to
your bank account in your country.

Waiting for your urgent response today
Yours sincerely
Kone Compaore
