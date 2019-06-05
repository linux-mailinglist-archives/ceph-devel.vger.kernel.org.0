Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8336510
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 22:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFEUFB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 5 Jun 2019 16:05:01 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:54475 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEUFA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 16:05:00 -0400
Received: by mail-it1-f173.google.com with SMTP id h20so5489422itk.4
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 13:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=zgG7ve5wHt8Xb8MTNgVa1JtZ3UuESn1PDJ9GAhpL8TE=;
        b=t+I5CjYtxNDKWkvvNBrURJHrE6cmx7kiGKBcbLge85cGbnMdu1GI3FRiRC9yM+eGzu
         DAuqutBXRjgmQK4/mpkl8UHL2DjZEHxxP78Q/8vVBthaI72iwB/jTQdQL+fH67nm+b2m
         6pfu5i1TM5ZDu5nZGe2D9QLMspmHRz3zfBUTD9igg7iZvGH2GNBR//W0GTy7kQttiUeU
         EmnLJzf8iw3B1t2EQrqxT1lYkjLAqGzQo3xPuz1KONxq7Hnb6yXvyor5zaylKTzgX7rr
         xIOx2NukP4Vw9bOINbm16P6KakdDneoQ/iNVwJh2vXRAZgIXqbaykpx1+qeT8iAQPrIu
         K0sg==
X-Gm-Message-State: APjAAAXpoGyf2FFel29FgYeD16+VVk8ICXig+k+taZBi4Y44/jkKX6bP
        bFa1z94B0Ps8n7lgw3feJSqe5CLeOai8pXmojiZza7K0
X-Google-Smtp-Source: APXvYqwHKcT156clk94+XZd8fSRzYbxcpyxV4keNk+ILnMYVpU63PRRQjkTij2L3mvCGTg8tYqSFKzvA8JxJX9a1Icg=
X-Received: by 2002:a24:9083:: with SMTP id x125mr21154136itd.76.1559765099413;
 Wed, 05 Jun 2019 13:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190604132003.4z6oxllc2ghcncle@jfsuselaptop>
In-Reply-To: <20190604132003.4z6oxllc2ghcncle@jfsuselaptop>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 5 Jun 2019 13:04:13 -0700
Message-ID: <CAJ4mKGaanO57aK1avp+N4uRocYh1m8qppVe+oEbiTqv7zZkyKA@mail.gmail.com>
Subject: Re: MDS refuses startup if id == admin
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 6:22 AM Jan Fajerski <jfajerski@suse.com> wrote:
>
> Hi list,
> I came across some strange MDS behaviour recently where it is not possible to
> start and MDS on a machine that happens to have the hostname "admin".
>
> This turns out to be this code
> https://github.com/ceph/ceph/blob/master/src/common/entity_name.cc#L128 that is
> called by ceph-mds here
> https://github.com/ceph/ceph/blob/master/src/ceph_mds.cc#L116.
>
> Together with the respective systemd unit file (passing "--id %i") this prevents
> starting an MDS on a machine witht he hostname admin.
>
> Is this just old code and chance or is there a reason behind this? The MDS is
> the only daemon doing that, though I did not check for other but similar checks
> in other daemons.

There's a pretty funny trail of updates there, but it's still
basically what we see in the MDS code: it doesn't want to turn on if
it doesn't have a specified name. "admin" is the default (ie,
client.admin) and so the checker is incorrectly flagging it as being
unnamed when the name is derived from a host short name "admin".

I'm not sure there's a good way to deal with that — we really *don't*
want somebody's misconfigured cluster to start up a bunch of MDSes
that all display as "mds.admin"!
-Greg

>
> Best,
> Jan
>
> --
> Jan Fajerski
> Engineer Enterprise Storage
> SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
> HRB 21284 (AG Nürnberg)
