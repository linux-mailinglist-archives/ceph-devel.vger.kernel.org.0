Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590F9483998
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 02:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiADBBO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jan 2022 20:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiADBBM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jan 2022 20:01:12 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C56C06179C
        for <ceph-devel@vger.kernel.org>; Mon,  3 Jan 2022 17:01:11 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j11so76451049lfg.3
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jan 2022 17:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drummond.us; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FhCziXSDIVqEHeqdeTNAEnAmaxA2oTV83a7FYCmISUs=;
        b=F3tiUyofNHmKDjVKk2XPN3VpXToJGh87luR1ns6i8fTdNqA4z8KYh9xx+TznQjoZjx
         58TqlIC/Vj4aNPJdMn0Qd4bZbVRnPNzaiJsnWmPeQALXVgD8VLO6jDj+VHazpPTPSB/1
         HWADwSJX1ZZu/dty1WaUP2KxY3Sw8VXiOiuQVgSrT0HZK6iCenP0DqyTmiLJ/HLXpAkt
         XV2/Qm1/GSgSHGlTEcr7ZdTgUQFmUi8gJrn/bzNGljU+2Io9kcqa3WpeXo9FQyxn1hSi
         ZpXEpEI9CKyeqqjCKo8dnjdUhHcpVlmwW0nTMezbw0pCmHnuNbP25JEqrHIUEfMvPFzO
         WX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FhCziXSDIVqEHeqdeTNAEnAmaxA2oTV83a7FYCmISUs=;
        b=oc8OlXFNJCF25+XJsCbcTn6FNNjZd3xI/8Pqp6xqAQikdHgK5PHmW8EmU0kIcOMij1
         zfaaYvwHHhV1Cop/qsxCwMpw7HnGGQC2Bf30foCAQfSpNg6wKVbyzhi7w2Ws4yfqSowg
         icWw0Yrk3f6nROjwSD4pdm1B+oacDZ83ZijlYr16fl72LYr3qE104UfyrTyeqVE0aWa4
         gDvJUpp7I6jchw2NBlQTfeoGK5j9rwo3Mev4sI4HnttNrkv7cuNHCfZR93LmYpXYPaqj
         gNo1g9wj7Luv1+Nbm4SdhvEjW9Jw7h3wtDFAnmwpWOSt7urluLwnG2PWTUvSFa3UFAHW
         JinQ==
X-Gm-Message-State: AOAM530nmiE78qwxuXn3y8B4Idmh/VRx8GNGLf1Up5TbI850JEbelANO
        O60IXgdTj6Irt+zL+6DkoK1/MtQoUnnzPKpdzdbAGg==
X-Google-Smtp-Source: ABdhPJwcgc1Ga1+rLCxU1YpJid0/47ry1/i0pez4n8tVA8yyD2kMd606iUiB5mCcPG+LT0NFgOGKtjbLaTH04xucoSo=
X-Received: by 2002:a05:6512:2083:: with SMTP id t3mr41569950lfr.595.1641258069695;
 Mon, 03 Jan 2022 17:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20220103181956.983342-1-walt@drummond.us> <YdNE6UXRT02135Pd@zeniv-ca.linux.org.uk>
In-Reply-To: <YdNE6UXRT02135Pd@zeniv-ca.linux.org.uk>
From:   Walt Drummond <walt@drummond.us>
Date:   Mon, 3 Jan 2022 17:00:58 -0800
Message-ID: <CADCN6nx4VWtR79TBDTENRExjsa=KAGuUpyz06iu2EGmSTPyc+Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] signals: Support more than 64 signals
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     aacraid@microsemi.com, anna.schumaker@netapp.com, arnd@arndb.de,
        bsegall@google.com, bp@alien8.de, chuck.lever@oracle.com,
        bristot@redhat.com, dave.hansen@linux.intel.com,
        dwmw2@infradead.org, dietmar.eggemann@arm.com, dinguyen@kernel.org,
        geert@linux-m68k.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        idryomov@gmail.com, mingo@redhat.com, yzaikin@google.com,
        ink@jurassic.park.msu.ru, jejb@linux.ibm.com, jmorris@namei.org,
        bfields@fieldses.org, jlayton@kernel.org, jirislaby@kernel.org,
        john.johansen@canonical.com, juri.lelli@redhat.com,
        keescook@chromium.org, mcgrof@kernel.org,
        martin.petersen@oracle.com, mattst88@gmail.com, mgorman@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        rth@twiddle.net, richard@nod.at, serge@hallyn.com,
        rostedt@goodmis.org, tglx@linutronix.de,
        trond.myklebust@hammerspace.com, vincent.guittot@linaro.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I simply wanted SIGINFO and VSTATUS, and that necessitated this. If
the limit of 1024 rt signals is an issue, that's an extremely simple
change to make.



On Mon, Jan 3, 2022 at 10:48 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jan 03, 2022 at 10:19:48AM -0800, Walt Drummond wrote:
> > This patch set expands the number of signals in Linux beyond the
> > current cap of 64.  It sets a new cap at the somewhat arbitrary limit
> > of 1024 signals, both because it=E2=80=99s what GLibc and MUSL support =
and
> > because many architectures pad sigset_t or ucontext_t in the kernel to
> > this cap.  This limit is not fixed and can be further expanded within
> > reason.
>
> Could you explain the point of the entire exercise?  Why do we need more
> rt signals in the first place?
>
> glibc has quite a bit of utterly pointless future-proofing.  So "they
> allow more" is not a good reason - not without a plausible use-case,
> at least.
