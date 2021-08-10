Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD13E5C5F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Aug 2021 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhHJN51 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Aug 2021 09:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbhHJN5H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Aug 2021 09:57:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476C0C061798
        for <ceph-devel@vger.kernel.org>; Tue, 10 Aug 2021 06:56:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso5533726pjb.1
        for <ceph-devel@vger.kernel.org>; Tue, 10 Aug 2021 06:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=h3aZTrCb62DNYhpJGTvZ4Kku5N7BEorxuPyN/PlVL+8=;
        b=a0JlewvCCcVHYkAJl3a+VbdMOodMUZOqmI75JJAFnVtHtWchCapSUVAi3h7HWtHEc+
         t/oJKvVZy0IQ34QZU125y5lltj7VYnrS2fNX6j2sU5R+e+axGZ73GSB6wM5QI7lJtkWj
         DDQSQLT0TpqckGN9cYh0f6rCRAMN5V+85gaW8nxaimzFksCHJ0oHSjH56O+9ikqygIbK
         48afCb7+cuUjO5hU7VtNGENXo8KR81oiH2EBcWr8kGhG+Bdr9qIB1h/hW5r64x33yuEY
         Q8R0H1e3LkKLZHMerpD/PIhtElsLfamgvw5ojnA2Cln2YUumYVcndd2cUYuVOX8DJ7WC
         GurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=h3aZTrCb62DNYhpJGTvZ4Kku5N7BEorxuPyN/PlVL+8=;
        b=nVFOrMEiIzHr2FUxl+q8gblUev4U+btab3D47mIxGQYydBJBGjuB45DEDspDPrPXjf
         X9RPdDKWWq+ny/HdQUqXIZXNRjEmPB5gjl5ebgYcqK3RqQYDWYZrtA0i3Yfb0QR4dJBy
         NxB/IfqPKe7KQoT0dQr0gMno4j6OLs1EfurNec9w+JxKV8s/7qMZdXbj+ArXdzv5qisu
         4pjPXn1poODbVhqqmkIn4Z16CB14eLFQH/bg2tEY58oQAk0CEl15Ly5o7C4wJTrif08P
         5qoQjB6sHjlZhO6lddby2W3yYmw0lTLQuKBH4lxONaqERVqlUYDoxonnqH9XnNu61URB
         8qwQ==
X-Gm-Message-State: AOAM533gkLH0Ww+hVa0RBD76txUg/XT39zbyrEs5r5VmafUtKt0zWGxE
        uE0XbUwJJIcbhE4fvGWnx7UWq3utp8jKV+TreF4=
X-Google-Smtp-Source: ABdhPJx8vgagkADVqWfuB5eKOStMbwawdMlgIfTSdOjHE4enkX1dqlSgja1EFMffaJMib58Zw396TqVPsmR8UOj6Jh4=
X-Received: by 2002:a17:90a:3f8e:: with SMTP id m14mr5230186pjc.227.1628603779850;
 Tue, 10 Aug 2021 06:56:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:12cc:b029:30:571c:5926 with HTTP; Tue, 10 Aug 2021
 06:56:19 -0700 (PDT)
Reply-To: manuelfranco4love@gmail.com
From:   Moses music <mosesdafom@gmail.com>
Date:   Tue, 10 Aug 2021 06:56:19 -0700
Message-ID: <CAEnNBfjeL6pUt=52-uaNZ_YNC_FcE-PgXUzr0Asgw9O0RuxAJg@mail.gmail.com>
Subject: Der Betrag von 500.000,00 Euro wurde Ihnen gespendet. Kontakt: manuelfranco4love@gmail.com
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ich bin Manuel Franco und habe am 5th. June 2021 den Power Ball
Jackpot im Wert von 758,7 Millionen Dollar gewonnen. Ich gew=C3=A4hre 5
Personen jeweils 500.000,00 Euro und Sie geh=C3=B6ren zu den 5 gl=C3=BCckli=
chen
Gewinnern, die ausgew=C3=A4hlt wurden, um meine Spende von 500.000,00 Euro
zu erhalten.

Kontaktieren Sie mich f=C3=BCr weitere Informationen unter:
manuelfranco4love@gmail.com
