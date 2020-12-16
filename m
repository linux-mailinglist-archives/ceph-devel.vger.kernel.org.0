Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EF82DBEB1
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgLPKfv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 05:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgLPKfv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Dec 2020 05:35:51 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32985C061794
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 02:35:11 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w6so16352193pfu.1
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W3uecCSYaS63jqrOLmllmdtp5SXwmZn8HN10HSdeiiI=;
        b=hLjWGdnUZrSajr/Ovryd463iCmfGRy+ff28EIc2WCEu1ePz4m40pTrLYpWDCmiYqgX
         iuT34pT5MIYqrfQWyD0RwbGaVAyGX3HUhQJiybJU37IF0QGZmz1fon8sbueAuWkTazdM
         ZvSJTOlrFqYwkv4jlv/XNsppkgfHgEd6rViPSAOovynv75lFUba53BDZPuxrCH/Px2NF
         5uiH3NzU2+hJh12lbp0RWO3FvXLAnBrZSsq3xWVgnJ0EbGJbh4AVu0OswZ/TheR9zono
         MYp4ROkzXRtljloCi8iNrRLsPFibmNlXV9vuklx3pzZYIj842y3hMKUWLR+6MVhtgv/8
         ADxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W3uecCSYaS63jqrOLmllmdtp5SXwmZn8HN10HSdeiiI=;
        b=lXk2mNMXXv0X3jtU0qG4uFwsx37XOLc7M60+wxD+Jaq5vKaAZShUc1FCtNSEUmMQ8i
         7DhndnU0pwefS0E23V8+vrKSbvdk7/MGY5N4+V4/zS3cBBUgk7QlAj5W0yMguuoim2d2
         Xc7MMfTw1FYejoheFnG57w4r1sBJeKwLIWbueOUejgYd7ODupv6S0ae/eEnmx0vEPc7r
         q1KAgsiWeYXpRgyUykPpt3q2hR6l2CNvcc3G5zxRn5NYVVOwhjt9xul7CDML3rJhkgw3
         EcGFThIxmCdHiDi6DmlAZV4A5+eP9bK3E1AbTIVIuAXoces/VONohIX+Up4vcyAeLSNl
         +coQ==
X-Gm-Message-State: AOAM531f78shNsmp1up8v2Q//Q6HNe2gWMBh6E0V5fDCIjVF+o2w8jCu
        0ic5YgfcM/o15cObZqMmTZqS3UqFR6e5dUvwiI8a1ZPRvXOtXQ==
X-Google-Smtp-Source: ABdhPJzwo8cyGR80v7N7u2dmoKXUInmP9KUf2Weawh4/flyn03ZpvI19ERc5fOJxyrum/ZUIre9zSjRfcAOlQtNMz1k=
X-Received: by 2002:a63:3155:: with SMTP id x82mr32104817pgx.394.1608114910776;
 Wed, 16 Dec 2020 02:35:10 -0800 (PST)
MIME-Version: 1.0
References: <CAPy+zYXDg4xFLiRE6e5iKZLokq2zSRNZrorPsbO68K=OW5SN8w@mail.gmail.com>
 <CAKOnarmeKE8EkwYqm5XtqnQnyYPchO7RLosr5BMw7eH83yPM1A@mail.gmail.com>
In-Reply-To: <CAKOnarmeKE8EkwYqm5XtqnQnyYPchO7RLosr5BMw7eH83yPM1A@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Wed, 16 Dec 2020 18:34:57 +0800
Message-ID: <CAPy+zYVokfBn2VZ2kv=sAPyMHPGdhB=96PXwY+WSWJKHyWynvw@mail.gmail.com>
Subject: Re: ceph rgw memleak?
To:     Matt Benjamin <mbenjami@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Matt,
Thanks you reply!
These days I add memory profiling code to RGW. Because
valgrind will slow down radosgw speed, resulting in no recurrence
The following is the result after the test.
ceph daemon /var/run/ceph/client.radosgw.An1H3c.4010609.140718309098104.aso=
k
heap dump
client.radosgw.An1H3c dumping heap profile now.
------------------------------------------------
MALLOC:       76501704 (   73.0 MiB) Bytes in use by application
MALLOC: +   3817717760 ( 3640.9 MiB) Bytes in page heap freelist
MALLOC: +     21446160 (   20.5 MiB) Bytes in central cache freelist
MALLOC: +      1908224 (    1.8 MiB) Bytes in transfer cache freelist
MALLOC: +     47477032 (   45.3 MiB) Bytes in thread cache freelists
MALLOC: +      9437184 (    9.0 MiB) Bytes in malloc metadata
MALLOC:   ------------
MALLOC: =3D   3974488064 ( 3790.4 MiB) Actual memory used (physical + swap)
MALLOC: +   1202749440 ( 1147.0 MiB) Bytes released to OS (aka unmapped)
MALLOC:   ------------
MALLOC: =3D   5177237504 ( 4937.4 MiB) Virtual address space used
MALLOC:
MALLOC:          10040              Spans in use
MALLOC:            587              Thread heaps in use
MALLOC:           8192              Tcmalloc page size
------------------------------------------------
Call ReleaseFreeMemory() to release freelist memory to the OS (via madvise(=
)).
Bytes released to the OS take up virtual address space but no physical memo=
ry.

I could use command 'heap release'  to set   page heap freelist is 0 MiB.
So the RGW memory is down from 'top -p ' command.It look like tcmalloc prob=
lem.

What do you think of it=EF=BC=9F
WeiGuo

Matt Benjamin <mbenjami@redhat.com> =E4=BA=8E2020=E5=B9=B412=E6=9C=8810=E6=
=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=889:41=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi WeiGuo,
>
> I'm not aware of a memory leak in RGW, but in the past when we've
> suspected one, we used valgrind massif against radosgw for a
> representative time sample to get a picture of memory behavior in the
> program.  That might be a way to start.
>
> Matt
>
> On Thu, Dec 10, 2020 at 8:14 AM WeiGuo Ren <rwg1335252904@gmail.com> wrot=
e:
> >
> > In my ceph version 14.2.5.ceph radosgw mem is high (4.6g use top
> > command).when I write 20m.
> > I noticed dump_mempools's buffer_anon is very high (3-4g)in
> > testing,after test,the buffer_anon has been release(about10m). but rgw
> > mem is still high(about 4.6g).So i think maybe some memleak occurred
> > in rgw.
> > Could someone can help me? or Could someone tell me how to tune rgw-mem=
ory?
> >
>
>
> --
>
> Matt Benjamin
> Red Hat, Inc.
> 315 West Huron Street, Suite 140A
> Ann Arbor, Michigan 48103
>
> http://www.redhat.com/en/technologies/storage
>
> tel.  734-821-5101
> fax.  734-769-8938
> cel.  734-216-5309
>
