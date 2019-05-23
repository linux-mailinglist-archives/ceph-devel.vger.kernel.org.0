Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516F428B2A
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbfEWUAh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 16:00:37 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38028 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387393AbfEWUAg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 May 2019 16:00:36 -0400
Received: by mail-pf1-f181.google.com with SMTP id b76so3830859pfb.5
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 13:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V9fqa6vGTt61NbhRzCoAy4pX1/08+vbL9AD8Tfl6xUE=;
        b=nBPUX6gXwsM0KxCjCw/OPuowewt6+19Ay5iEV+6SXqfxVASUh+E8dRMBhMyRKkXY5z
         NB+hfjHzJEt+harDGy1SeNP4Zh+xQdEYGXek8W6214iCgiyH3AWDZPsnG31CkL05e2nt
         hrah5CIbUrn4zMQWBCBWLm/hgkWRljSh14FNexDrowK1MnQFuZ3IuEU/sn3M1S2OOIUV
         TC4EreWP+1XxnmlpD1a+FJsUv1ay6BVpBqN9Ptu8TIRV12ycYRVkPhvleJUUawdKbwdp
         tK7QTRTxEryJEixELVCP/KPWAsUNaKsd3HWL5ILrduLuIiTGnQV2hysANDAj81y+M3r6
         vCWg==
X-Gm-Message-State: APjAAAVf00on4CkglufhUdVCLcQx9lTrv0QIaVY1uueAXd9SfHXnLX15
        fwniDwBFAU63O33H1+3o0DPqtv9QvsA3UnMHE78MUg==
X-Google-Smtp-Source: APXvYqwXSm5AO+J3Qky6quWlLUTEAbcoo1NlFNmYH03hxl/D56YCIY7N7VO6KdM1l/uTTlR2UyFwhyyakJ2DUjS0PbY=
X-Received: by 2002:a63:e24c:: with SMTP id y12mr76504394pgj.276.1558641635839;
 Thu, 23 May 2019 13:00:35 -0700 (PDT)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Thu, 23 May 2019 13:00:24 -0700
Message-ID: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
Subject: 13.2.6 QE Mimic validation status
To:     Sage Weil <sweil@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        "Deza, Alfredo" <adeza@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Details of this release summarized here:

http://tracker.ceph.com/issues/39718#note-2

rados - FAILED, known, Neha approved?
rgw - Casey approved?
rbd - Jason approved?
fs - Patrick, Venky approved?
kcephfs - Patrick, Venky approved?
multimds - Patrick, Venky approved? (still running)
krbd - Ilya, Jason approved?
ceph-deploy - Sage, Vasu approved?  See SELinux denials, David pls FYI
ceph-disk - PASSED
upgrade/client-upgrade-jewel - PASSED
upgrade/client-upgrade-luminous - PASSED
upgrade/luminous-x (mimic) - PASSED
upgrade/mimic-p2p - tests needs fixing
powercycle - PASSED, Neha FYI
ceph-ansible - PASSED
ceph-volume - FAILED, Alfredo pls rerun

Please review results and reply/comment.

PS:  Abhishek, Nathan I will back in the office next Tuesday.

Thx
YuriW
