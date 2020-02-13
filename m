Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2122A15CBDE
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 21:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgBMUUE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 15:20:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728673AbgBMUUD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 15:20:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581625202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4LjR4uZdevdl/aMZtvVKsTJXU5wU5FPOIUvZuRnhGhk=;
        b=DR/F8WMo6fWk1p5216eHPyEsTxH+2nZAZ7ZTohVwP7aAtM+DhrHCx+Pi5wkU+kcYg92bit
        eEXsicPEpIQST6htXaM05gTwk4yurzV3xyJ/xLUHoy2wV/LWdRtJjruOfYtsne5rG7jXlg
        AUNszM+u4xY2pbYFSVXkvzbjaWUO1Wk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-RoH05xpFNlaxz6fENkD12Q-1; Thu, 13 Feb 2020 15:19:55 -0500
X-MC-Unique: RoH05xpFNlaxz6fENkD12Q-1
Received: by mail-qk1-f199.google.com with SMTP id d134so4548790qkc.0
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 12:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LjR4uZdevdl/aMZtvVKsTJXU5wU5FPOIUvZuRnhGhk=;
        b=uhIDzDRRHdjNcNeeMoVAYsnnFJJL4KgHjaPmA1J002cPXwgh2U1t93KKXnQA3DqTu/
         22jEha5CTw/MZZttxsS5alUtujA3n94z8J2r3RbiqKM3LC9+J9pk7hXJjdwneF5pcF+w
         cmoGCf05bPjyhvkm/jOEaPgwTqxkbgF/SuPZCqBfltebLnY1CHaQVXEETIALoanTg8Hq
         7dSV4i6ejXLkJzt4DqaqMB3hlEhG6jtsNo3AFgwWAmfCACuRi4QERR4iMlpt+LYj2qi7
         GAdAWoeIIHdXHnMN+J6XIzt64/h5cvIPPKEhj0hwT1LcePWxw/FlcBf6uTzxl50J2sVl
         gQrA==
X-Gm-Message-State: APjAAAUOE/+SmTaTsrBGwmFbb+rbHr0PelJCt7hT2MZW0JYPmpF6I4lL
        0MaFXfGCmwFaWfgeCVkqGxWHlUGQtjJO6azGTZvscnmzugjYE+lrC80XpjVZVQhRasikDQzrAb6
        6eDQllFZ6TJn6jkfUPcJkTFCwGx45u1y9pAfxnw==
X-Received: by 2002:ad4:4949:: with SMTP id o9mr12815491qvy.189.1581625194576;
        Thu, 13 Feb 2020 12:19:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqy20W5fns6SPtLwBH3t2xNIQS9VV6rt+R96nTvuyNAo7hlZ6DajucTFqm/CKEZUqgZyUbRzfuGwNri4tVh8hr0=
X-Received: by 2002:ad4:4949:: with SMTP id o9mr12815476qvy.189.1581625194287;
 Thu, 13 Feb 2020 12:19:54 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
 <CAKn7kBnRSm0NX5Z0sfZneG98jz_pP+aH-qQJrAwkumJihpBdTQ@mail.gmail.com>
In-Reply-To: <CAKn7kBnRSm0NX5Z0sfZneG98jz_pP+aH-qQJrAwkumJihpBdTQ@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Thu, 13 Feb 2020 12:19:43 -0800
Message-ID: <CAMMFjmHr2R1wynMEiELYPY1R0c0mAG7GZstbFVxhF5ZvLwzCRg@mail.gmail.com>
Subject: Re: Readiness for 14.2.8 ?
To:     Neha Ojha <nojha@redhat.com>
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

I see more PRs tagged
https://github.com/ceph/ceph/pulls?utf8=%E2%9C%93&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa+

Casey, are those newley tagged rgw PRs a must for 14.2.8?

All - pls remove "needs-qa" for PRs that may wait till next point
release, otherwise we are shooting at moving targets.

Thx
YuriW

On Wed, Feb 12, 2020 at 11:52 AM Neha Ojha <nojha@redhat.com> wrote:
>
> Yuri, there's nothing other than what's already in your queue from the
> rados standpoint. +1 to starting QE validation after that.
>
> Thanks,
> Neha
>
>
> On Mon, Feb 10, 2020 at 11:57 AM Yuri Weinstein <yweinste@redhat.com> wrote:
> >
> > Below is the current queue of PRs:
> > https://github.com/ceph/ceph/pulls?page=2&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa
> >
> > Most PRs are being tested.
> > Unless there are objections, we will start QE validation as soon as
> > all PRs in this queue were merged.
> >
> > Dev leads - pls add and tag all RRs that must be included.
> >
> > Thx
> > YuriW
> >
>

