Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF9A2E5B9
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfE2UH3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 16:07:29 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39111 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfE2UH3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 16:07:29 -0400
Received: by mail-io1-f67.google.com with SMTP id r185so2992421iod.6
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7q0Sakd1TMkC1/w4DpfOGtUEuXYbC69ZIx84jI1pQE=;
        b=DOIjodoKBpVvicd8iDtrrwhif6Fib/sukeSD0x56bYmuIi1beWgtXwdytda7dWQgMd
         gJ2U5BibWYNUP2VaPQxUld1xky26JJBe0Ywg6g4AGWVI57ApfHMaGaai7ThzOR2KE0b7
         mrt1w7wiTb22NSefuJS1fE0oNa2zhUNQ4XBSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7q0Sakd1TMkC1/w4DpfOGtUEuXYbC69ZIx84jI1pQE=;
        b=JsgYXbDrOTUCzu3RsUlAVowgZQURFHqmpZ0PtbkmYIROEuLmETk31bJ7+X9A91/bfJ
         uO8b7W/MowKUmiADO/xlUn5Pl9vG0b/mgF2bNETDbwnBInnimXQ7gX11g3L5sCnqPmR0
         cYAJsWZ95Fus6sqHfnAdDu3xOKkoOeYcY8ziFSWsw0xMP7opQvTT/rbb4u1dF0fhJ19U
         UF5YGm9OkJc2CP27VPBnbY6olIm0mjZ3PTdIHW6rykzLv/8jDGhqgbV+339Cr/596CTf
         pHiN4ZPbxfBulTJkurMB4jiZmJMSxZWYhuGypm410bGB4Sf+pEje23Ijr3UwzaQwXjWn
         q9Bw==
X-Gm-Message-State: APjAAAXlM0+/qcT/8Sd2GjEXhReBqctgAxZ+CeRQqe6KQV3xbX/M3tbG
        Pq6T/v6gOlnUKq/4wRd4LTjQtYxiVukiA1OP/k8wDQ==
X-Google-Smtp-Source: APXvYqwLZb/ME4zrVxF6lxBEvoSyJfBdg+7QPeUl990G3Qs2vdNuL/EBUo+uiDuS9u57oCFZKxBV641QCIayNm/fiJ0=
X-Received: by 2002:a5d:9f11:: with SMTP id q17mr20213351iot.212.1559160448108;
 Wed, 29 May 2019 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-12-amir73il@gmail.com>
 <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 29 May 2019 22:07:17 +0200
Message-ID: <CAJfpegsft_1TZ-OjaAdmGE--a8+deCQwFjbcAYJsEdbp2YWQSw@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] fuse: copy_file_range needs to strip setuid bits
 and update timestamps
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Luis Henriques <lhenriques@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 29, 2019 at 9:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Miklos,
>
> Could we get an ACK on this patch.
> It is a prerequisite for merging the cross-device copy_file_range work.
>
> It depends on a new helper introduced here:
> https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

That likely is actually an unlikely.

Otherwise ACK.

Thanks,
Miklos
