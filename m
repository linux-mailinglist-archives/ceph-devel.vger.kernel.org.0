Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D8C1A867
	for <lists+ceph-devel@lfdr.de>; Sat, 11 May 2019 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfEKQZf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 May 2019 12:25:35 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43147 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfEKQZf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 May 2019 12:25:35 -0400
Received: by mail-pf1-f176.google.com with SMTP id c6so4848122pfa.10
        for <ceph-devel@vger.kernel.org>; Sat, 11 May 2019 09:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=81b8ZzzrT+juPJZhGn+/Q5+YzJN/dF3a+1Bupql/N7A=;
        b=rdpFtXtxMI4r8EPGy3aECWrq8UKEoljKYxL2GD8AdNVslARp9VY+Qb391R6Wnfyfdc
         Jg5XU3nvIQlmdSODr7owPbJkZ8/zkbimHtiDlrUmpAEeanvJWtLDZX4jfxwbdFhHV0Qn
         7XEAysIjc3teWxdFzS4I+23gmsVToArSs85xk3/D29SA7E3oO4LYbElBPmBwCeM0lm6F
         srrJ8/fWjaEh6t2/VMyyV+geq6qlynueY0M13cCwKiibehP32zypz+iWkvU03hooKPH/
         yAIoE1AsnLH36g+LRvAJbyA9Xd9J6zpZQ0zZBDjf1aiMo25/rRR406m9no5jkv9KZ8xY
         r3PA==
X-Gm-Message-State: APjAAAXF7U+tPxcpt/oNLMICZNL2AW0jdk63XfRMnN/bBKbwyXDlaKCY
        ZctHpTUYbVJjVgGZq6ia6mRq9m7ZeK40unwrAzqZjnoO
X-Google-Smtp-Source: APXvYqwBf0+VIh0CLJiYl5/cyxK4Qk9AltruJxX2UTlHeRaSOQgKCVelAL1uqaJWV7YFIV2Z6vs3Gw3PWIJ+EIWtvHo=
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr21660274pge.318.1557591934438;
 Sat, 11 May 2019 09:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
In-Reply-To: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Sat, 11 May 2019 09:25:23 -0700
Message-ID: <CAMMFjmH28geRKWpveQY3aWQCBp=_pFjOb_5YNchS_-bLxh_g+Q@mail.gmail.com>
Subject: Re: PRs for next mimic release
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Nathan Cutler <ncutler@suse.cz>,
        Abhishek Lekshmanan <abhishek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All PRs in the queue had been tested and merged into mimic.

So the 'mimic' repo is locked and we will do QE validation next week.

Speak up if you still have some PRs that need to be added.

Thx
YuriW
