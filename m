Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C015F6E1
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 20:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbgBNTbP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 14:31:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58984 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388256AbgBNTbN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 14:31:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581708672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=jZXArXFo+R/q37W/pjdzHyyB33jhWsNmt76bSotUrmo=;
        b=XBkloY2JiUbRHuQmPjtBD0t/prIytY9XyFsOLcFjrPofnm0S82CVuB0qDjWdeqb8ebOfj+
        9NcjHA2uGoIhEyuRjmUMTdqPFqZ0ekS9WOWKJ9Ieh2WBjb0rexT6Mm4OrTrgA4w5UQe3L+
        Bw3HsGFnghoRAKw2J9B6RMClL1wwciM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-GaukJMIWPAaAQQ_NdYQB3Q-1; Fri, 14 Feb 2020 14:31:10 -0500
X-MC-Unique: GaukJMIWPAaAQQ_NdYQB3Q-1
Received: by mail-qk1-f200.google.com with SMTP id z73so1276272qkb.10
        for <ceph-devel@vger.kernel.org>; Fri, 14 Feb 2020 11:31:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jZXArXFo+R/q37W/pjdzHyyB33jhWsNmt76bSotUrmo=;
        b=XipUzX6FcRqQPWTEmFn+1lUH/7hI72bBPUoaQUvekB0ALAwmnKKlbPPbMYk4bAIVDh
         6Qn1iUAKLEXdmGwbYzZFBrVRXdkd7TeXyawyBPUOgy7oJ8tWFXU5rql2k+ZNHNA612jn
         DtTVFkpkfXFJdO6j5Hd948u/1zVMH8GstskmI9KYv2gIU3NGf92UhhP5vKQ5VVJyZngP
         xoV66xpdbSW7sd0QLALbPzhtac0SmBhZoLoksnIEta6hsrBAumCC8bIf7LG0eMdi+fvN
         z3DITJKeQH+bqR6ONK/G2j1rSzfAJIq/Bjc1oUtCql00kevYzrp94oYGZAm0em2DXPPi
         PD1g==
X-Gm-Message-State: APjAAAXDdFpXaqauqvdhppKiJKDJlll29IhV3fM4MHw3QH92+odWd6QW
        oyQcBSXSHQigd3DZPTQ/a+iRRv1zjV73/OkWpa8mcG8p61YxZeRbDhZr5SnvP0OjQjQZiPW8Qgf
        Hh7rd54xJHn95uMe5y+FBOoVJU35kjvsxkaEzqg==
X-Received: by 2002:a37:7245:: with SMTP id n66mr4368941qkc.202.1581708670224;
        Fri, 14 Feb 2020 11:31:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLv4ZHydAF4Bs4imx6TDGfyhSXYZEy28FuOgDn7GhRx0uuDDq9INTnlOldUSs5mOoP8hHuQMCXbbxG3OTW6iY=
X-Received: by 2002:a37:7245:: with SMTP id n66mr4368898qkc.202.1581708669996;
 Fri, 14 Feb 2020 11:31:09 -0800 (PST)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 14 Feb 2020 11:30:59 -0800
Message-ID: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com>
Subject: FYI nautilus branch is locked
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
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We are getting ready to test 14.2.9 and nautilus branch is locked for
merges until it's done.

sah1 - 4d5b84085009968f557baaa4209183f1374773cd

Nathan, Abhishek pls confirm.

Thank you
YuriW

