Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCDC15CD9F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 22:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgBMVzq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 16:55:46 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44260 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgBMVzp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 16:55:45 -0500
Received: by mail-oi1-f196.google.com with SMTP id d62so7386313oia.11
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 13:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8J20ZWRYjJLx4OrBjPwCdQFfsEMdQSJ01O7lEOjxZo=;
        b=F1xegbAyYzHbm9KqL0KhEmliUOmEEjS41vdwqg436YBfsW1lLEYxA3HK9mNFawDjho
         lIymLjiomYtdCH5OQdr2V1Au6+1CMAQCmKdbBcxgpZQvbh+ItHHbKitZsAnhjORA+lEF
         +itl1lrrMsvkX1GTqG2ZJHD8zcObE7aHvd8jmr0J5zRUcMy18e4rZKJL/ucO3EC/fFpa
         0AShguwsLNTN5uvkv3qztzKD01grzQbx4Mbt/CF9KgiioSIvovXe+65fo6ZZSQylZUy1
         c6yfy9f5t0GQP1CIaYYc/0rqzUCPDBDgyEdI3xaPeVdwN1EyOHAjLLKa4NAWD9rzOAe8
         XKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8J20ZWRYjJLx4OrBjPwCdQFfsEMdQSJ01O7lEOjxZo=;
        b=a+A5L1yhE48Bs3G70+O1C8od2PmgdzyTQPoljzIwacT0N04MLtSsUp42Y17o7ZzyzI
         4Bjs0cEx2CtOt5yJ9/nwaXxPeYNkCybMYXHlDaHiccWTXeUanrMaL1f/PpMSDXzi2wQy
         Ey3m8sdb6300IYmLJt73Ni3XALfsysBnMDdCSoDR4wI9j7bEcaB84PbAHVM1TfL/ECt8
         oJbJUIIkfI+NnS0KP66QI1EJMeiyaV4pyb0agiK7Lap+HEXRcOLXF8xHlzPiXSN4Bg+0
         cCwYKSdS6rKRk894pJAXFKaf1fb31KFKiGPdiLL4yFAtS50ZryjEF2P5oYzDnHS+5ATq
         DMFQ==
X-Gm-Message-State: APjAAAXVyADvN9P87/QJZHNSocRAlEaFVPD4mFevWhzp3ShIt5hBeWs3
        uqAWnqS1ZvcpzglPkS8E2p39OxvRSU4Qg1OFLlE=
X-Google-Smtp-Source: APXvYqzQlGqAAfOg7DwYJNWJnz27kb0YQCVtwnA4MyDSF1bJoJSROJpI76Sw9by24r5WSxYvHW87LVak8mTmhl6F6UE=
X-Received: by 2002:aca:ad11:: with SMTP id w17mr4537951oie.85.1581630943807;
 Thu, 13 Feb 2020 13:55:43 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
 <CAKn7kBnRSm0NX5Z0sfZneG98jz_pP+aH-qQJrAwkumJihpBdTQ@mail.gmail.com> <CAMMFjmHr2R1wynMEiELYPY1R0c0mAG7GZstbFVxhF5ZvLwzCRg@mail.gmail.com>
In-Reply-To: <CAMMFjmHr2R1wynMEiELYPY1R0c0mAG7GZstbFVxhF5ZvLwzCRg@mail.gmail.com>
From:   Nathan Cutler <presnypreklad@gmail.com>
Date:   Thu, 13 Feb 2020 22:55:31 +0100
Message-ID: <CABNx+P8L++MhGkdqZ5U4HxL4hoEDF7MRCYiERP-VwHEfgjtENA@mail.gmail.com>
Subject: Re: Readiness for 14.2.8 ?
To:     Yuri Weinstein <yweinste@redhat.com>
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

> I see more PRs tagged
> https://github.com/ceph/ceph/pulls?utf8=%E2%9C%93&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa+
>
> Casey, are those newley tagged rgw PRs a must for 14.2.8?
>
> All - pls remove "needs-qa" for PRs that may wait till next point
> release, otherwise we are shooting at moving targets.

Sorry for putting the tags on more PRs today - it wasn't my intention
to delay start of 14.2.8 QE.

Can't we just start QE testing on what is already merged into
Nautilus? Does it really matter which PRs are tagged?

Nathan
