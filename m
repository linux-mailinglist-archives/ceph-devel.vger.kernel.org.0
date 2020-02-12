Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5845515B15F
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 20:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgBLTwy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 14:52:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30134 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727361AbgBLTwy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 14:52:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581537172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5F2FBb2w4p3I3nn1LxYgT+S+g0X5QFe5OneByA7O9JU=;
        b=RJhQPmOEZmrTO4BM8ToW7tqq36KNzKIGDlCg6p+raflQzopACvcYehQm2bPHaRNnHn3Vqw
        BxFhIvnm5M4ahNLNJTp2oD4h4gkH2ef5ZmGbuvw1kO/BalK3Mva8xChAXjBdtBaWnbjcGy
        gm2M9on+pC/30U0WSpbEnonoGjm/VdQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-u2jKuz8xPkenNWDqA6GbCw-1; Wed, 12 Feb 2020 14:52:50 -0500
X-MC-Unique: u2jKuz8xPkenNWDqA6GbCw-1
Received: by mail-qv1-f69.google.com with SMTP id k2so2026779qvu.22
        for <ceph-devel@vger.kernel.org>; Wed, 12 Feb 2020 11:52:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5F2FBb2w4p3I3nn1LxYgT+S+g0X5QFe5OneByA7O9JU=;
        b=JPwEF/reBvrXnQe20Qq0kMbwP1hkO3uARv639eqwldU/VWQ+tgOgOQEHDXbtG/K3tS
         MIK0ExRGZ7G7ogTeV8azYLstyC+lmSgSAZbpkPPVt8W5Bmqu1dYnMTmpDQIcVj1llorR
         aiHCLcbKEO159lPJkz0fgiBYyvlFJyk47LhU1rB9PTvTUbafj37OP8f4DlRFTbdbsQAr
         tsC1JYO+vv/PEE96/cB4OS/d8ANvxE8JmqicEwJ7ywO6p7ggZQa4+agR1WqQQ1Oh2iyK
         g+V5sb9Jm4EKZ2vdvfGeQfo5uo/DYC49s5iN04yVeF3ULdj3OO3IXrY5WaPboo9n4Fsr
         qRzg==
X-Gm-Message-State: APjAAAV80p4Ixm0TAQq2D10U+65lTfdzGVX1qH01urvxXP7Mq42XXPa+
        QnQVyklza2cZTj32iiCVGHYbWK8ojVucw7VJTHmpS4Teb6fp2wGzfmcDxUMZRNGbenzxE0Ky/cn
        qkHKMqHZel6OmnZM/77RS0rA9wB/uZ3DkSZEKLQ==
X-Received: by 2002:ac8:1385:: with SMTP id h5mr8423971qtj.59.1581537169965;
        Wed, 12 Feb 2020 11:52:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqyW8AvFaphv4BI9n1koHtKpLOjqjEvtyoHWV+BG21cdmnW8gh/tdw88DZ0pwbH6tfarJO1LY05f3umtA2aZWF4=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr8423942qtj.59.1581537169740;
 Wed, 12 Feb 2020 11:52:49 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
In-Reply-To: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
From:   Neha Ojha <nojha@redhat.com>
Date:   Wed, 12 Feb 2020 11:52:38 -0800
Message-ID: <CAKn7kBnRSm0NX5Z0sfZneG98jz_pP+aH-qQJrAwkumJihpBdTQ@mail.gmail.com>
Subject: Re: Readiness for 14.2.8 ?
To:     Yuri Weinstein <yweinste@redhat.com>
Cc:     dev@ceph.io, "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
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

Yuri, there's nothing other than what's already in your queue from the
rados standpoint. +1 to starting QE validation after that.

Thanks,
Neha


On Mon, Feb 10, 2020 at 11:57 AM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> Below is the current queue of PRs:
> https://github.com/ceph/ceph/pulls?page=2&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa
>
> Most PRs are being tested.
> Unless there are objections, we will start QE validation as soon as
> all PRs in this queue were merged.
>
> Dev leads - pls add and tag all RRs that must be included.
>
> Thx
> YuriW
>

