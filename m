Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C1C437C6C
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Oct 2021 20:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhJVSHj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Oct 2021 14:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhJVSHh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Oct 2021 14:07:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F9FC061764
        for <ceph-devel@vger.kernel.org>; Fri, 22 Oct 2021 11:05:19 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t16so8299967eds.9
        for <ceph-devel@vger.kernel.org>; Fri, 22 Oct 2021 11:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=F26I+cBcpyIkdxRfcHLvmvj+TTSmfbBclURHJNpWXCA=;
        b=fVaB6sAqDTo9oFZviuxWm1qH3BY4eTM835XLNi3nNxuNuW12lJE5HHT4sdKmRagBMn
         XhAEB+GtzaMpQaYkAymXmlk1HiSSbHnfF3tp7TyQjORDa6dfOITbYR/+ezCn6JbPVt/h
         cU3rVijuPGsiHijansyUhNo8/k4cpu4Smh7zhg7j/7tpP27R77AmLqYaQVl1K5MidzK7
         0HlDOIxlJ8+LlJeCHf8sM89K70+NKHOEK6FQ1oaTpjD3IA+SB3Kh+HkUZWLGKI2sI7jv
         adYRKjB3FU74DP7GrKqoYle17ShkX5an+XIbmJaLhHyNXuF7A2hthduTfF4Oo1cEdI36
         BZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=F26I+cBcpyIkdxRfcHLvmvj+TTSmfbBclURHJNpWXCA=;
        b=lBs8RHQR6zGPMmJLmOJL1XxuevPtyavw0p5eZPwjWerZY1G2TvqAKR2ZbZzKrrWMwi
         8r2ozeZ7bNeaha8UEY1gW2pvaVfcVGQSpdKdMd0lnRjZyOmr9lLkvaIlF5WFDfWb13p9
         AtWU1g6lAxMTWDkZG6eyK4jrxSkPEOb9ptKCZgdi8qsiv5Zk6fBwJEKelbc7RNoRNL3G
         hYOhwk9SqHKIDA9eVgpEVA+Bcs6/1ngB0g4tQHgThfSLbdUewqp5cimt4Rd4nU0F4JRn
         jjVgNqpxWUbYVNDspYt4BMXzbQB60Rr6ctfuEMEi0bBy4q9ioJZeKv6S2FkiI97GmKlc
         zmpQ==
X-Gm-Message-State: AOAM532/joiU0s/EkA059y3vaZ1RVQhAYrW7YaYbXC3ZrT//9nInnY04
        EuYqAPyetzMJK4qiuXR5XNQcl7LmrOFJUIXoRpA=
X-Google-Smtp-Source: ABdhPJyZc3ylgGG+FZswgpQd7mXQP1unFMyfnvCs7vMKRMsaxtOCMTXauTgIgBD4WvMn8zoyFbspb8dn+VlNpL8EUUw=
X-Received: by 2002:a50:ec06:: with SMTP id g6mr1913330edr.241.1634925917543;
 Fri, 22 Oct 2021 11:05:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martinafrancis01@gmail.com
Sender: julietdrogba55@gmail.com
Received: by 2002:ab4:a16c:0:0:0:0:0 with HTTP; Fri, 22 Oct 2021 11:05:17
 -0700 (PDT)
From:   Martina Francis <martinafrancis655@gmail.com>
Date:   Fri, 22 Oct 2021 11:05:17 -0700
X-Google-Sender-Auth: QrxROBry-FG0QxZ3OfKjgeBzFxY
Message-ID: <CAFKw7MCvvACMiEr+uMXiZUKQ5XE8YVS90Rz+XUaPF0eW_q20=A@mail.gmail.com>
Subject: =?UTF-8?Q?Dobry_dzie=C5=84_moja_droga?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Dobry dzie=C5=84 moja droga
Jak si=C4=99 masz i twoja rodzina.
Jestem pani Martina Francis, chora wdowa pisz=C4=85ca ze szpitalnego =C5=82=
=C3=B3=C5=BCka
bez dziecka. Kontaktuj=C4=99 si=C4=99 z Pa=C5=84stwem, aby=C5=9Bcie dowiedz=
ieli si=C4=99 o moim
pragnieniu przekazania sumy (2 700 000,00 USD MILION=C3=93W USD), kt=C3=B3r=
=C4=85
odziedziczy=C5=82am po moim zmar=C5=82ym m=C4=99=C5=BCu na cele charytatywn=
e, obecnie
fundusz jest nadal w banku. Niedawno m=C3=B3j lekarz powiedzia=C5=82 mi, =
=C5=BCe mam
powa=C5=BCn=C4=85 chorob=C4=99 nowotworow=C4=85 i moje =C5=BCycie nie jest =
ju=C5=BC gwarantowane,
dlatego podejmuj=C4=99 t=C4=99 decyzj=C4=99..

Chc=C4=99, aby=C5=9Bcie skorzystali z tego funduszu dla ludzi ubogich,
maltretowanych dzieci, mniej uprzywilejowanych, ko=C5=9Bcio=C5=82=C3=B3w, s=
ieroci=C5=84c=C3=B3w
i cierpi=C4=85cych wd=C3=B3w w spo=C5=82ecze=C5=84stwie.

Prosz=C4=99, wr=C3=B3=C4=87 do mnie natychmiast po przeczytaniu tej wiadomo=
=C5=9Bci, aby
uzyska=C4=87 wi=C4=99cej szczeg=C3=B3=C5=82=C3=B3w dotycz=C4=85cych tej age=
ndy humanitarnej.

Niech B=C3=B3g ci=C4=99 b=C5=82ogos=C5=82awi, kiedy czekam na twoj=C4=85 od=
powied=C5=BA.

Twoja siostra.
Pani Martina Francis.
