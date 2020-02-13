Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CEB15CDE8
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 23:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBMWN1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 17:13:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54693 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgBMWN1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 17:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581632006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mo9kwlZesfX/uJ5Pz7L/5AcUAyZ4C75G3w2MV/QOXvs=;
        b=B5mIoJCn5oBBzagJDxk5UVWm59Qug+Qh1xSobEDOweG1557Bej5pr1gYDCEFnpZ9Fy5A9f
        pcblSYa8se5grv9MsoD/jIjzCYhP4EWAfaDjzHzCjZqBDP1aijRCBiNB/GJHkDyWT3l/sA
        0Ht16ZtaC8TROMryM/P4HHc7Ae2NVBk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-gLCo2XwgNq2mdfGU2xe_FA-1; Thu, 13 Feb 2020 17:13:23 -0500
X-MC-Unique: gLCo2XwgNq2mdfGU2xe_FA-1
Received: by mail-qt1-f198.google.com with SMTP id r9so4705425qtc.4
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 14:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mo9kwlZesfX/uJ5Pz7L/5AcUAyZ4C75G3w2MV/QOXvs=;
        b=JToQU5jHaH51eaHy+YURuA7lfmykPCgI04B33ZzuEf6k0VT90NMNWMH4Pe3n0cz22f
         yZXv/PPa3B27zeSnMife3rnutD3v8FIc79Riqsciaa8KKErWP7s7roJenCfqzx8ElelU
         as89fJq+DYXBfimBOjgTqHh2YJGgJp7xSjcIgslcE++2dLAJ6+1LWhRkHpgWc+tKpTx8
         nRMtYprVfJtz4gXq5UA3yVAaNYNfz56/tpAsCgfjuRRO05pcHI5l3Aj9UsEBO34HvtlW
         85KaOIouc3EdeX/jg6kN2kb26lby8RWFjKbR77kFiPGG3R0aNC9LD15Yw1zucOU6Sr1c
         BSbw==
X-Gm-Message-State: APjAAAWN7A1cwu2EqzCSwEzcglMPW6tmuPJSeYNKNXUcIljFJE/RYR9G
        qWaamy9oCF+bP0YuLWZUtqYefPNx/m3yju+CNOD+HQRv8WVnqygdZRTvNGNjk9TF+96bY1ess8C
        bPqUvP801iplThgPrNf4pN9zcSdJdug+quc9ELQ==
X-Received: by 2002:ac8:6b4f:: with SMTP id x15mr219955qts.152.1581632003471;
        Thu, 13 Feb 2020 14:13:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqz53qvMBf7ZuhxC8bbYqr1PKkk572dB3NEBXz8YZiTXJGbup3vJTNHXmYr1ZX1+vtnoC2R8kXgmj47Z3jw6XkE=
X-Received: by 2002:ac8:6b4f:: with SMTP id x15mr219915qts.152.1581632003260;
 Thu, 13 Feb 2020 14:13:23 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
 <CAKn7kBnRSm0NX5Z0sfZneG98jz_pP+aH-qQJrAwkumJihpBdTQ@mail.gmail.com>
 <CAMMFjmHr2R1wynMEiELYPY1R0c0mAG7GZstbFVxhF5ZvLwzCRg@mail.gmail.com> <CABNx+P8L++MhGkdqZ5U4HxL4hoEDF7MRCYiERP-VwHEfgjtENA@mail.gmail.com>
In-Reply-To: <CABNx+P8L++MhGkdqZ5U4HxL4hoEDF7MRCYiERP-VwHEfgjtENA@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Thu, 13 Feb 2020 14:13:12 -0800
Message-ID: <CAMMFjmE=3jEq1Gneox5uZD=-AeOsSy4p2tDgYOz04P5Bk2-jjQ@mail.gmail.com>
Subject: Re: Readiness for 14.2.8 ?
To:     Nathan Cutler <presnypreklad@gmail.com>
Cc:     Neha Ojha <nojha@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
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

If you say so yes !
:)

On Thu, Feb 13, 2020 at 1:55 PM Nathan Cutler <presnypreklad@gmail.com> wrote:
>
> > I see more PRs tagged
> > https://github.com/ceph/ceph/pulls?utf8=%E2%9C%93&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa+
> >
> > Casey, are those newley tagged rgw PRs a must for 14.2.8?
> >
> > All - pls remove "needs-qa" for PRs that may wait till next point
> > release, otherwise we are shooting at moving targets.
>
> Sorry for putting the tags on more PRs today - it wasn't my intention
> to delay start of 14.2.8 QE.
>
> Can't we just start QE testing on what is already merged into
> Nautilus? Does it really matter which PRs are tagged?
>
> Nathan
>

