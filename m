Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243D333A9F
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 00:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfFCWCk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 18:02:40 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:36843 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfFCWCj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 18:02:39 -0400
Received: by mail-oi1-f177.google.com with SMTP id w7so2690317oic.3
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 15:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kI+1g/U0aC7Wdqzmj1N7l416XRBzmB/AL3vVtQgVEEo=;
        b=OK6ZuR8+vuYSqgJNg/5AbaMRrqyND0vU+XIIfXSf+k92s5a98el8yy07wk07hjsjhO
         jxe3+YKvkL7kp8zAuS91wJBkzzHYr9bUzg4PzdS3+ygOyVTAKZko/s7KdiKixum66JEj
         JS9VcBuRnwW/RiknRLGd8ZecM8EMJdKAabX9oC/lXyWMhJ+LpmWh8xpJjfvlhDI/2pZV
         sWnzVP2w7wyoE96ptVBNcF691g9QbaG8KPWQ3cR2huNjpJ8jeXIoJ79fqIyJDGLk53nH
         HSiE2hKPC5YoL4+gJ6RJESS9nP2FRLfpFygY7RpBIoLv3ZKmNgJ/6MhGUk55uewF1gVq
         /Pbw==
X-Gm-Message-State: APjAAAXMfuaZwkczgt7GvuV2cqQGduf1NI4wdRG1M3Kc2ZGNs0HAZcXM
        4DoKDj6hwFSa7h1FNx1sXdR39o/i7jdPQfLHspqdf5Nu
X-Google-Smtp-Source: APXvYqyRVlBbGAMtTUhSxuB2C/B4P5sdAnBQ8pAxb/tAplcbtuVDEGAnEKe8k+qKq8Y4K+HEL57eQrms1ogN8l4S/DU=
X-Received: by 2002:aca:6087:: with SMTP id u129mr2229754oib.70.1559597601397;
 Mon, 03 Jun 2019 14:33:21 -0700 (PDT)
MIME-Version: 1.0
From:   Yehuda Sadeh-Weinraub <yehuda@redhat.com>
Date:   Mon, 3 Jun 2019 14:33:10 -0700
Message-ID: <CADRKj5TsnRdjuV+01Lhv2hNbB4sv4UXxo_m--pnhdiTJ60GAvQ@mail.gmail.com>
Subject: S3 Select
To:     Karan Singh <karan@redhat.com>, "Bader, Kyle" <kbader@redhat.com>
Cc:     "Weil, Sage" <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Karan, Kyle, ceph-devel,

I'm looking into a potential implementation of s3 select, and trying
to gather some information about current use of this feature. Karan,
is there any specific use case that you have in mind?
Anyone else that has any experience with this feature and what users
expect exactly from it please feel free to chime in. The different
directions we can take implementing it vary a lot, and there are
likely different trade offs that we need to consider. Any light shed
into it could be really useful.

Thanks,
Yehuda
