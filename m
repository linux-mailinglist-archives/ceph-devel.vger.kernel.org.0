Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FD52B142B
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 03:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKMCI4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 21:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgKMCIz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Nov 2020 21:08:55 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E236EC0613D1
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 18:08:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b3so3773886pls.11
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 18:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U+tyHoASzP5x/Mksbk7prp57nkt63lLOrO8FFA2ktxM=;
        b=vR69DQhLMxlZ5vNqkrQlfxFmJio385ptguN1fKu8ZVm1dhi6dCzaOsepVHGyu2E4qQ
         tX8jW9xqvnw/LCzrLALP2929A/TpxsEK0UmceGJJEjzBzeOgizxnGIRh1OlyTnBYuepS
         lbBXLvw+lTI7NDLziw7mwLYVpyjkxzjP70pgC8dqxpWdlaYnzzYF3w6pJkx4zVsHXoXJ
         7Q62Kd7TVsRS8H+JCehsnaAr1mqVfjd01X8SdhNmrwJGt0NXU2sSq2qUxiS8dOBBZ4E3
         TpYRSVxsB8FM2CbijdIkvbYa3yHcDIwE+1XRQN5UAH+GiN4IpODr34N6njQAEzC8s6F8
         pVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U+tyHoASzP5x/Mksbk7prp57nkt63lLOrO8FFA2ktxM=;
        b=CFa8eqRg/ld035krbFjFDlQw7PvxnCZXWrTa5nJZN2k60nRJdJwt9hOV/G9kCMbsq5
         nNypJFfL2oRvp9FvjBlGEA7UcPWAB7ke/XzHBOg2zzyXwQhBgocmaIrd0n7kKiYF3oB6
         MmK5aaD2DyJpxScqQayUMHBuCcV7FCVNRip8OFauC4GANTQEpmEJ1ReanpasVY49lFDj
         zaRy6X7vTpB7ytRYrOFZsmkfE/Ax5UF//Gyd0kbDTk5ik2xAwgcEvleNJWaKPh4vmRK+
         8vuHBGvDEFDoUGJ7+HThRbtvL/tYEckDQLt8hxYMet+sx5TeRrMj4hCHyTF7CzXWxLyS
         qQcw==
X-Gm-Message-State: AOAM531MNIFtMX+bhmPf5/8ovpw/S7Euan2JQ7pvAUUP+QBM80fXBbyW
        XZJehBfZWCFAQ9LM9VRxhihevZ1oWp8EaBwVdVmuluaV6zFe5A==
X-Google-Smtp-Source: ABdhPJylSrMSzKWwT4OFbrIiUtlK9q30aLwavKGwEVpLkCnMmHiPQkgc/qGO0Ja5vZk06cHSQb9/PW68UWEKGxvHM2E=
X-Received: by 2002:a17:902:8e84:b029:d7:eb0d:2fe6 with SMTP id
 bg4-20020a1709028e84b02900d7eb0d2fe6mr2420187plb.16.1605233335472; Thu, 12
 Nov 2020 18:08:55 -0800 (PST)
MIME-Version: 1.0
References: <CAF8vKShnH+xas+kLAcXL-Cxt6C3TF7TbP4Wfm0h48pEGCmsR+w@mail.gmail.com>
 <cf0b22ada6eea3a23b84a945208066aeadd822b3.camel@kernel.org>
In-Reply-To: <cf0b22ada6eea3a23b84a945208066aeadd822b3.camel@kernel.org>
From:   Sage Meng <lkkey80@gmail.com>
Date:   Fri, 13 Nov 2020 10:08:42 +0800
Message-ID: <CAF8vKShk8h2xz_+5qwZ=VkPGtnFkfw_u-5+6LP-_88=ahpKb2Q@mail.gmail.com>
Subject: Re: Is there a way to make Cephfs kernel client to send data to Ceph
 cluster smoothly with buffer io
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It would be nice if there was a mount option to have such parameters
adjusted that only influence CephFS Kernel Client.

Jeff Layton <jlayton@kernel.org> =E4=BA=8E2020=E5=B9=B411=E6=9C=8812=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=8811:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, 2020-11-12 at 23:17 +0800, Sage Meng wrote:
> > Hi All,
> >
> >       Cephfs kernel client is influenced by kernel page cache when we
> > write data to it,  outgoing data will be huge when os starts to flush
> > page cache. So Is there a way to make Cephfs kernel client to send
> > data to ceph cluster smoothly when buffer io is used ? Better a way
> > that only influence Ceph IO not the whole system IO.
>
> Not really.
>
> The ceph client just does what the VM subsys asks it to do. If the VM
> says "write out these pages", then it'll do it -- otherwise they'll just
> sit there dirty.
>
> Usually you need to tune things like the dirty_ratio and
> dirty_background_ratio to smooth this sort of thing out, but those are
> system-wide knobs.
>
> Another alternative is to strategically fsync or syncfs from time to
> time, but that's sort of outside the scope of the kernel client.
> --
> Jeff Layton <jlayton@kernel.org>
>
