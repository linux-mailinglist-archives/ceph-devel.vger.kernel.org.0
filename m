Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E60C28DE
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2019 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfI3VeC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Sep 2019 17:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbfI3VeC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 17:34:02 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AB8981F19
        for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2019 19:07:46 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id w7so11910846qkf.10
        for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2019 12:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xJtPoD2/R8uUy8o+0TQYLanbWKnaj2CP2HOj7anZ7ig=;
        b=sMFB5c70G0V2rhC/SBDyUazRZllFXgpJIsFVchqUGEGUXaAEcywgoBG0A3xx2ecVmi
         7LYLupOj5GSS6yf0kFsOQIRfWcQEDJkHpcEGg/50Hfg4PyqM+UdZ4OtWDCAKwnEtDM77
         oyxo5k7Q+YJ1Ol6I4NTloHY+8P7RtZ66WVIMuXN3bU+S1pgLD+smaF/ZRZ716UFmU7TO
         ePu/b5kGamR3P6CmVuINdD+HffVCxyRR3r4a1yI84GcImhscpIyMJ+IWZwUUKxUdyT10
         IbBSXrwgEyToRy4DV/A3tTNNALkEruy9PzS6fizVg4/YYoqk1cOah/5tB0Yy7Y8YZZLX
         Anig==
X-Gm-Message-State: APjAAAWObE9y3Txh20fwd2hi4lPaGwWu1gVr9dF1aFRtkg8gPtkNp3ww
        Z4isiiYn80AHl/Vpujn/1ux8qXqNFRQ1q0nzQP7+YTycGBQaGcfrIgqTgGHTIpl2ukfGq3KMeRj
        Py+UIVG6XyR5Vnlur0scTqaFqxPD1GlcJeplCcA==
X-Received: by 2002:a37:624a:: with SMTP id w71mr1767391qkb.456.1569870465930;
        Mon, 30 Sep 2019 12:07:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0IQI3aX86MDgQFfN+Efms1Gs0uxe2rGSnEDbEb+gECfEnNPjV2mpkOO++XFPYPBh3ut3QiMnOpk12c3XM2j8=
X-Received: by 2002:a37:624a:: with SMTP id w71mr1767364qkb.456.1569870465672;
 Mon, 30 Sep 2019 12:07:45 -0700 (PDT)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Mon, 30 Sep 2019 12:07:34 -0700
Message-ID: <CAMMFjmF45_GCVCMnL+qbLLn2AJybTj-UiYJY9F9s8E2XxT_wZA@mail.gmail.com>
Subject: stable point releases backported PRs
To:     dev@ceph.io, "Development, Ceph" <ceph-devel@vger.kernel.org>
Cc:     Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        "Weil, Sage" <sweil@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>, Neha Ojha <nojha@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Casey Bodley <cbodley@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

 Hello all!

For stable releases pls add label:*-batch-1 label:needs-qa so they can
be tested and included into next releases.

(* for luminous, mimic and nautilus)

Thx
YuriW
