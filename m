Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA232170CF3
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2020 01:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgB0AHo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 19:07:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726413AbgB0AHo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 19:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582762063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=lvfBxxRVXkV5hcBasOnA/07EoTrtbF59B5IHvDBc2eQ=;
        b=FuI6P/Y66J7LH7qR374oZYYHJEeSJ6X2kimiFg9wvK7c+LbEWTzE5LOM3sZc+BmG58nSdh
        xLYmoGGQvjRMb1cYueGnsCHjx7ry0NbrA4dnxvV0ndIzRw+TZHIdYKOyGc+Zoc5MIIAH2d
        Vvm6yO6ThVmWG85ZTWSldCn2kGvD0os=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-0bLTlqiDPo-8_Ynq6SbQ-w-1; Wed, 26 Feb 2020 19:07:40 -0500
X-MC-Unique: 0bLTlqiDPo-8_Ynq6SbQ-w-1
Received: by mail-qt1-f200.google.com with SMTP id r19so1072643qtb.10
        for <ceph-devel@vger.kernel.org>; Wed, 26 Feb 2020 16:07:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lvfBxxRVXkV5hcBasOnA/07EoTrtbF59B5IHvDBc2eQ=;
        b=ZAvOfyx0zWKRPIh6DKd4RJpDCxBGgfBkkYpTFGWLdx8U8ff5V3GecR8f3NC21BQYea
         duT2roci+Col6hVCFbvivlC+Vcck+jJr97XR+bctg0jYDX8aGNkKg3mZf4NCIpmhV3Ks
         5BBwc8S636ZZjiizLoTUEUP+oPpezQ+wFkAq9kaYtU2Rj89VYqMGt9VitJONIABFD/cK
         FGraLHGLiW4ZK4TQ7PGGhSydaLi85SPDAchk0cebqaGd7hZO/XfNXs4PhhiV8RT4uJY7
         vFEUx1C2/X+RRxC/wkD2YC59oAGoLr3DIun1LtQwI+xWa2H+F72R0Dv3liIpqUuV2mxy
         J4Nw==
X-Gm-Message-State: APjAAAVOT+2fl8F/t/V72cFgMgg+RVyp0I+J5+0i7qHKxYno0/XaM4MN
        rnEB3iFHU6vI53jy9EBpQC9/rTO+BL+t/8Xj3yVqhN3n/ZCrnBdk5lgSp5+byOYKhmE1appDxdg
        Zlw2KFeWavYDgx/rHr0y8FpPpA5rf3ZZgNA74qA==
X-Received: by 2002:a37:93c3:: with SMTP id v186mr2202276qkd.456.1582762060368;
        Wed, 26 Feb 2020 16:07:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwk5L8DWcBjTFEw9hwtNmNuQRRvPfeOW7WseGl57wcpup017h7HNmetGYYG1wwjSXiiB4EMqXbC45QWXjkby8=
X-Received: by 2002:a37:93c3:: with SMTP id v186mr2202247qkd.456.1582762060068;
 Wed, 26 Feb 2020 16:07:40 -0800 (PST)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Wed, 26 Feb 2020 16:07:28 -0800
Message-ID: <CAMMFjmFAB2E_h7VhrCOBz-EUHHk0nrB=JSudfcOhCpA7FwNd6w@mail.gmail.com>
Subject: Readiness for v13.2.9?
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
https://github.com/ceph/ceph/pulls?q=is%3Aopen+label%3Amimic-batch-1+label%3Aneeds-qa

Dev leads - pls add and tag all RRs that must be included.

Thx
YuriW

