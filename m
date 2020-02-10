Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7321583F4
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 20:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBJT5e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 14:57:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727003AbgBJT5e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Feb 2020 14:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581364653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=fnm98rDgNCh7jSYoaFu5Z3W0xvl/qWZyAfwWxvxbTVQ=;
        b=AatpRim7qMx7jM57zZ4SjDYb+XxVeBxwsOBaEvRus0IPgkMZDCtvZoZv4F0lzfrEVPO7PI
        QjcFmFLR4DQpMCGSpR3h1eGS+Of/MIgl25TIBq9ELXgbUd4pPltcYGUUudU2+oAC4I2RYL
        OjF3K5eqc9SmG6Y22ex6LxsR01f/02k=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-Wxs25xexN7GANzXZesM6WA-1; Mon, 10 Feb 2020 14:57:31 -0500
X-MC-Unique: Wxs25xexN7GANzXZesM6WA-1
Received: by mail-qv1-f69.google.com with SMTP id p3so5705290qvt.9
        for <ceph-devel@vger.kernel.org>; Mon, 10 Feb 2020 11:57:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fnm98rDgNCh7jSYoaFu5Z3W0xvl/qWZyAfwWxvxbTVQ=;
        b=lNMaX9XcMKXv7kW35RvYQcciIMz7/3wtYH1teg/KuRwsAdu9OFZWjygu1eqoTquHFx
         NIWLNqXmo2BykNADJTuMsQA+ES7jC8XSLHtPMNz5VICQNFjWsIWcQtvxC6QHeZfRT1Ue
         RJQ0A4SEJGRAPrRki4q1NZo5vEyI/OEVa/E1wkX7zjTcCT5TLjtJ0W1vbhhqi6C48Yoi
         X6OSRIIIHtH58Vx8G673sJ6E4fcXGmR1TyOVOrw3ppnhwoKtP9xkdetUoXX3zf4w2VDV
         8z2Zmb1H1fskTeZa5AkypxROhJ/tMX8ku9/I+Wcf7lh0XmOqw7dl8TsHnZ7QCnCulhKY
         T9og==
X-Gm-Message-State: APjAAAWZPXzvqaZjt6pNoPrdrnOFXGRaJAVi4C/hJbVXCdL+ry2cJjlp
        oCLFYfqsp07CtOtB3t3paIEYBet68dN/HYiznVXG0Hj5xcGWieQ2ORFybIoOxuFF+TgtZljYYnC
        +w0LAz1R0beWcHztclk21unf7cdhiwZF/cvzNmA==
X-Received: by 2002:ac8:2bcd:: with SMTP id n13mr11732368qtn.21.1581364650577;
        Mon, 10 Feb 2020 11:57:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNPiPapDVtJFMCld4lnJDvU3PdPx5UJJlaX8cA+uI+GNzidk2mznw5VXGC01Y6rvlRvRCGBb7Jv65CsbAxdXE=
X-Received: by 2002:ac8:2bcd:: with SMTP id n13mr11732335qtn.21.1581364650246;
 Mon, 10 Feb 2020 11:57:30 -0800 (PST)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Mon, 10 Feb 2020 11:57:19 -0800
Message-ID: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
Subject: Readiness for 14.2.8 ?
To:     dev@ceph.io, "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
        "Weil, Sage" <sweil@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>,
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Below is the current queue of PRs:
https://github.com/ceph/ceph/pulls?page=2&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa

Most PRs are being tested.
Unless there are objections, we will start QE validation as soon as
all PRs in this queue were merged.

Dev leads - pls add and tag all RRs that must be included.

Thx
YuriW

