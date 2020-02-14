Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5615ED1C
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 18:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394655AbgBNRcD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 12:32:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57399 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394652AbgBNRcB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 12:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581701520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/zogos+bsew1bUEL/l9vjeiAfC6Wk1KzWPIv+/tZ38=;
        b=HXYlXQYHyVUjBwkCZe3r3PEO1oaaytn2ZSC4BsNaMsnHPoRGuh7xmLFH4Ak7IYR00M5CVd
        aj1xrNwavinb3RDQt6yVxJCF1b8df2sAhjlZKLF0/S5OeN5YBGpUmvYgxlBz5WW0F9zPpR
        z0FhynGOtFFq8jmE5hqduegfGonJ/20=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-hI9GGSUVM1qW8iT2PUUKTg-1; Fri, 14 Feb 2020 12:31:58 -0500
X-MC-Unique: hI9GGSUVM1qW8iT2PUUKTg-1
Received: by mail-qv1-f70.google.com with SMTP id dc2so6139769qvb.7
        for <ceph-devel@vger.kernel.org>; Fri, 14 Feb 2020 09:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=0/zogos+bsew1bUEL/l9vjeiAfC6Wk1KzWPIv+/tZ38=;
        b=cqD8xqXrhe28GhQCsgPyvCaZG+CTYt3gsU8mjpNDvYF9b8WXo/pht+TpeGil1AoqSN
         2HLyu151BIgZUThiO2SAefYg3Af6e6QbIK6U96E6Al0SsPXbhwy0Vh6nm9BWLPXhVT08
         1Ne9qS+Jlqcgv4aS70mhE/1n3bDaN6WnXdLf6Cz+FK54fXd7ZAvOdQTEwaUdA/VRRayg
         4Lx8YPDtDgeUsIZFRCtet2koftT/iLfZFozRMAJOT+wLftS8CZeiwzfzUx477KowWxOr
         p8sLITm34u/ma0Ed3jg12eMSNAaBJZcxhlWJ8o+zrDwKLC3EtO1vGMNjIrbatdPdm5rz
         Ltgg==
X-Gm-Message-State: APjAAAXnJfI2Af4DXF39YdmtpFscUh5w79iEYCBnP2Lu5056Pjs1MRFk
        ewFDLt4HrOScM60oKjaxezg5F+SjzwhMHy8R08zD6+4rTbh/PmAbRouNAoRoqKrjCoHFPYdCv3m
        N8n1/ADV5gHT43i0ZO8W07Q0F3Ov/qYso9CrdIg==
X-Received: by 2002:ad4:4949:: with SMTP id o9mr3040709qvy.189.1581701518166;
        Fri, 14 Feb 2020 09:31:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyqPktIc8wQiMz5MHne61z1w4VNJusHJZD3zbAHzPxl5/12tGU8KJPT9F60MypA0CDINT++yRmhiAoNQWZH9/Y=
X-Received: by 2002:ad4:4949:: with SMTP id o9mr3040687qvy.189.1581701517912;
 Fri, 14 Feb 2020 09:31:57 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
 <20200214171554.l7ibzoo64uthd2ke@jfsuselaptop> <CAMMFjmGDBQf+K5K2Zz4e6-PJS=y1YoUAEm5_X0tTUTre3EmZgA@mail.gmail.com>
In-Reply-To: <CAMMFjmGDBQf+K5K2Zz4e6-PJS=y1YoUAEm5_X0tTUTre3EmZgA@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 14 Feb 2020 09:31:46 -0800
Message-ID: <CAMMFjmFQ0OnDzBbgb_Jp=Ci3VEHmjfVo=25V5KE71kGOqwH_ng@mail.gmail.com>
Subject: Re: Readiness for 14.2.8 ?
To:     Yuri Weinstein <yweinste@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
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
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

corrected back to 14.2.8

On Fri, Feb 14, 2020 at 9:25 AM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> Thank you !
>
> Correction  - the subject line should say 14.2.7
>
> On Fri, Feb 14, 2020 at 9:19 AM Jan Fajerski <jfajerski@suse.com> wrote:
> >
> > On Mon, Feb 10, 2020 at 11:57:19AM -0800, Yuri Weinstein wrote:
> > >Below is the current queue of PRs:
> > >https://github.com/ceph/ceph/pulls?page=3D2&q=3Dis%3Aopen+label%3Anaut=
ilus-batch-1+label%3Aneeds-qa
> > >
> > >Most PRs are being tested.
> > >Unless there are objections, we will start QE validation as soon as
> > >all PRs in this queue were merged.
> > >
> > >Dev leads - pls add and tag all RRs that must be included.
> > ceph-volume is ready, al backports are merged and tested (thank you Nat=
han!).
> > >
> > >Thx
> > >YuriW
> > >
> >
> > --
> > Jan Fajerski
> > Senior Software Engineer Enterprise Storage
> > SUSE Software Solutions Germany GmbH
> > Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> > (HRB 36809, AG N=C3=BCrnberg)
> > Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
> >

