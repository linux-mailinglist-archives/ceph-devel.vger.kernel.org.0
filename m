Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B7C114897
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 22:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfLEVTf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 16:19:35 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44379 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729187AbfLEVTe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Dec 2019 16:19:34 -0500
Received: by mail-lj1-f196.google.com with SMTP id c19so5199800lji.11
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2019 13:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p/5DUiJNUvTvn0ngWEENA6E5/rRQQAGsoL0gXtjWTaE=;
        b=RBRuYauI47ubpHmTcCCApQyzGgJHEh2S0LTdKqjeDtcwDoQ3f42FSm0NGn3QOkrjmx
         BTAMzCY4AzuZtb+azMbdOGZfG5SbecMEbid/TrFo6CC2Gwj6JBLKgZAeHLtdmva91Zw5
         +9JbkxvgQKwJjpu/8vep7+gvTbeGBnohVAe+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/5DUiJNUvTvn0ngWEENA6E5/rRQQAGsoL0gXtjWTaE=;
        b=nwDx5BQi8tdY9e3IJY19hnuHY/sL41itw6jODlYpWeEV66znhvJ3NR5WXb+JFWh1aE
         L1l63wus+D2avexIFT0NtY/nsuXxivBhK3aKaL+k3++8izhoP4e6k+hswiVnJ8XRoXDe
         JBeuRDv73UiXhNGE/NPv0UcPRO24sQupIbz9viJTpWDg1LGMNIDsiipSrQdjbFfO6zkq
         0VuqLreTZ6GSumER8n4R2vv9iL9Sgp9bSbZ4k96B4PGoPfRronhIOL8aC6KaoIt1fZuO
         OvgCklnnBNmCnpcBzIsi9zC9P+FrIKlz1RhClsv30SO7qO1/4trLqt96Teu1sMZSMrDO
         RD9w==
X-Gm-Message-State: APjAAAUfkfMJueavc6q41RfmeQlvVY3167RA95IEYUBH0+zyhl6MUs/1
        nupk1AbSiO4EgwOd/8bevlDkzHsmOdc=
X-Google-Smtp-Source: APXvYqwNAG2XdipZ4UDexsFq4/fMY6O6rtNyegCalm1I6qUTriNgadJhScitjIwYVOpUCOMzwpoH3Q==
X-Received: by 2002:a2e:a0c6:: with SMTP id f6mr6741718ljm.46.1575580772304;
        Thu, 05 Dec 2019 13:19:32 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id h24sm5506258ljl.80.2019.12.05.13.19.30
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 13:19:31 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id y19so3577807lfl.9
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2019 13:19:30 -0800 (PST)
X-Received: by 2002:a05:6512:1dd:: with SMTP id f29mr2419467lfp.106.1575580770512;
 Thu, 05 Dec 2019 13:19:30 -0800 (PST)
MIME-Version: 1.0
References: <20191204200307.21047-1-idryomov@gmail.com>
In-Reply-To: <20191204200307.21047-1-idryomov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Dec 2019 13:19:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjm+9rJvh=aRahfoN7z6waV87Eqr=-i_Cb7zOwHrugf5A@mail.gmail.com>
Message-ID: <CAHk-=wjm+9rJvh=aRahfoN7z6waV87Eqr=-i_Cb7zOwHrugf5A@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.5-rc1
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Dec 4, 2019 at 12:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> Colin Ian King (1):
>       rbd: fix spelling mistake "requeueing" -> "requeuing"

Hmm. Why? That's not a spelling mistake, it's the same word.

Arguably "requeue" isn't much of a real word to begin with, and is
more of a made-up tech language. And then on wiktionary apparently the
only "ing" form you find is the one without the final "e", but
honestly, that's reaching. The word doesn't exist in _real_
dictionaries at all.

I suspect "re-queueing" with the explicit hyphen would be the more
legible spelling (with or without the "e" - both forms are as
correct), but whatever.

I've pulled it, but I really don't think it was misspelled to begin
with, and somebody who actually cares about language probably wouldn't
like either form.

              Linus
