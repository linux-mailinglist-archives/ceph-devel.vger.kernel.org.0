Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1410913227
	for <lists+ceph-devel@lfdr.de>; Fri,  3 May 2019 18:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfECQ0d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 May 2019 12:26:33 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:32940 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfECQ0d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 May 2019 12:26:33 -0400
Received: by mail-pg1-f169.google.com with SMTP id k19so2968743pgh.0
        for <ceph-devel@vger.kernel.org>; Fri, 03 May 2019 09:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eG/aYPJzGxpML9Qb8amwSnyDIN8LX4gzCZYjYUv9El4=;
        b=DAApawTKFLYPQxSNylali+GH1EdS4ABZYwDuvIxUPflR4fn8yZjOvLps3icsT8z3NG
         d13a+BTKjl7BekRVHOu+MXzV1HKmgTxjMRPtraJW41up0EfyylHG1mqOMKizAUVLHQcD
         /5hj7tA+wKVHp13apTJjOVQrCC/IFNzY+dXbOvEQ+QDSZfzELLwy91QmQWhyz/t2VNqG
         Y82gsDMuGjA3/xbzRYYXJo3vLDr6zoGOlRYtP0aXc8Lb0mnxcwilzIi6S4cv6p3DeqvR
         W9JUHwNmRpEkWIj2FgNJoloFiY9bsfOdr1VuhuucZnLE3gAi6pJ8BDgw7I08P1Q08V6S
         IkpA==
X-Gm-Message-State: APjAAAUQGDjO0gZpJxj456PB9V8uJ3VzsdF37z+4/LpkIObJZzx4Qxp8
        9+6y0DyJjXqN1CnKP9ky/a2tNdz5kAZ4PnPsebcBsSRQhcE=
X-Google-Smtp-Source: APXvYqyRdK8UF/LUFvCw+iv7XSYo4h49jI9+HuKcVBEzCxvshlNUYUP6+lXuZVQKa7pQvum2Puxxm1VWu07/9vGjT8E=
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr11482909pge.318.1556900792239;
 Fri, 03 May 2019 09:26:32 -0700 (PDT)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 3 May 2019 09:26:21 -0700
Message-ID: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
Subject: PRs for next mimic release
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Nathan Cutler <ncutler@suse.cz>,
        Abhishek Lekshmanan <abhishek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In preparation for the next mimic point release pls tag your
backported PRs with tags:
"mimic-batch-1" and "needs-qa" so they can be tested.

Nathan, Abhishek FYI re: backports

Thx
YuriW
