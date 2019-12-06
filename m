Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22103114F93
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2019 12:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLFLES (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Dec 2019 06:04:18 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34974 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFLES (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Dec 2019 06:04:18 -0500
Received: by mail-il1-f194.google.com with SMTP id g12so5922274ild.2;
        Fri, 06 Dec 2019 03:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+K2i2NBMzFxBPENxFOj55e/4N2mWKkV/KyZn4aZDJ/E=;
        b=J+lO5rdeGz/uq0GRKk7Vlr5+fkJbi9Q/1L1Gwh+GLdHU53JmXXqwGZSMXm4oTnW/pJ
         xFdXk3URIBtlYttPmbi80Mq2JLb2ijEE/qFoMXLoZlwOeNlLDSfkVCFL3UUPA3BikOgv
         oWM8lcunhgf4MF6NvE7wr1iJBsgDKzvIj3chFPjOlSB143YYRduKSiACDtZ4Svc5+T72
         A4svWQQNE8vdhl7W6uOVrUWI6gKNE050XWF7CwV66vQCdRScdvKt7A9qfH9P9LrTbj0B
         DDgMm14YybtG8sEkxlQnl1SIK0Fm7uSmviAK9gKti8JayhDQsXq9pmj2CKEKEYoPmZIU
         VD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+K2i2NBMzFxBPENxFOj55e/4N2mWKkV/KyZn4aZDJ/E=;
        b=LylePvITvvCyTax2LjGOM7QrjgnW1Yi3uNsWVesRsl6huPyT+Tj6+XcdsQERqrJ5LZ
         7UX5sGvGFH/p+hWd3zdT/4OGkwk11b2j0PiSfqCs0JCYIiM1HVXamtYcM5q41eKLYEoF
         NkDqLPa7CThSZsfSpT2l3TzIbzjgARzOzcIg0quZbgrFHfGmu3azHTakiRmE6VzT8s7X
         mAmVvXbnyub3eVGQ4JOoQs7w/3zXQBE7b/OldxOig7W8Zsr3LesbJF3C8jhJk+mjuOku
         XZH+D+qifX597LkeOYL87Rs7x2fCDVbI8ddPLZsgLB3SL0YYXNSBfSpvDkSnQyRwcm6t
         9gaw==
X-Gm-Message-State: APjAAAVe+UxrnEyzIk3vrHPp1sQisyRsLenhitb4Frx0iLJC1HWzZoNF
        SLm0Iy/HdGd7Oc9nAyuwgnMus42dIfqTMBl8S0w=
X-Google-Smtp-Source: APXvYqya8X01NYggP7t3CVoWZjUKlt/yGkpN4d2gA6d/51cmQjMCHZUZmiorAjcnVj4Xoyt4OswyArH2DattCHmByvo=
X-Received: by 2002:a92:b749:: with SMTP id c9mr13076534ilm.143.1575630257440;
 Fri, 06 Dec 2019 03:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20191204200307.21047-1-idryomov@gmail.com> <CAHk-=wjm+9rJvh=aRahfoN7z6waV87Eqr=-i_Cb7zOwHrugf5A@mail.gmail.com>
In-Reply-To: <CAHk-=wjm+9rJvh=aRahfoN7z6waV87Eqr=-i_Cb7zOwHrugf5A@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 6 Dec 2019 12:05:01 +0100
Message-ID: <CAOi1vP_biwOVuG9U4nemfH803O_ADHGgjmd0_6eL-ZJhyrkOYA@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.5-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 5, 2019 at 10:19 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Dec 4, 2019 at 12:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > Colin Ian King (1):
> >       rbd: fix spelling mistake "requeueing" -> "requeuing"
>
> Hmm. Why? That's not a spelling mistake, it's the same word.
>
> Arguably "requeue" isn't much of a real word to begin with, and is
> more of a made-up tech language. And then on wiktionary apparently the
> only "ing" form you find is the one without the final "e", but
> honestly, that's reaching. The word doesn't exist in _real_
> dictionaries at all.
>
> I suspect "re-queueing" with the explicit hyphen would be the more
> legible spelling (with or without the "e" - both forms are as
> correct), but whatever.
>
> I've pulled it, but I really don't think it was misspelled to begin
> with, and somebody who actually cares about language probably wouldn't
> like either form.

FWIW that was my spelling.  I suspected the same thing, saw it being
used in various spellings, but since Colin is a native speaker I took
the patch.

Thanks,

                Ilya
