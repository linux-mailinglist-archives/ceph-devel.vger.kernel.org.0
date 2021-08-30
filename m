Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229F93FB8D1
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 17:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhH3PKZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 11:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhH3PKZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Aug 2021 11:10:25 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F35DC061575
        for <ceph-devel@vger.kernel.org>; Mon, 30 Aug 2021 08:09:31 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so18755219otf.6
        for <ceph-devel@vger.kernel.org>; Mon, 30 Aug 2021 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=My+KW4wMsggXXB2SdRlw/CFgMo/CDeI8+GV22ZFWOwY=;
        b=F7DKfhX8hpsk31V3GL6tjTZZo9fcxeCEXQSud0/xrAF0eUHyi117/Awu2LJC4m4knj
         s2MvmMJEh+jq4yPvO+FPsee6xLtOCuUEtIRkR/+6z3+TqWGzYtANk3eGRP4z4RUrj1S/
         mUm/DppMp88kC8Sy/HFbCGqntsnuvvBt7UBbRaRuaExpm2hudXwN4d3SQMEUMqLzhw9s
         2pTV70zY6j6cn7tmDeH5607eOMe8alCtz+3whV4tYzjYDPrEMt6zYyx16I3N0q9uAwMq
         Cw10Rp+KjrSXlj3vMt9z60707PyGslyihpQP04/foxaVyDiFX9KVUmWHA/2mfzLuwcpa
         RACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=My+KW4wMsggXXB2SdRlw/CFgMo/CDeI8+GV22ZFWOwY=;
        b=qI7WC+p2eDyIuY12SwUVqapNOeQ4cxXHuv+Nd4TnpXqH2LNxPRShL1gbjh+hIFRzTk
         ob3ebDyuJoy+XD1JOFGflJSKUbafqogFg+PQZb7xT/PKj4UGbITZPGky+cHnkwx6Hsx+
         Yu2v8zpFYMWxgQsu3pteBSo3G/ENJlKtXt7IrfT8zmim3fDE2cXhqY2coCLBYT/0KkhM
         8B81t06Ci/JqCVMCaa0tQ0ELJ3GfxUv3hNse3J/XX7CbUp0v4rsdFF6oPwgkIWj4VW/I
         ZnAykNYxvDCpkXP4zZD7C+mXe2iwBjfBhKWDm+BjriNZTuTXPN2VkHFB7qXDWkeHERvy
         U2mw==
X-Gm-Message-State: AOAM530Cmig8V9djOLJyn9PFQKMuYkiImq5UT9tbKGsiMizonUx+3RIv
        Xqor7Dfk/sBmWxE5kLf+z4v9ANugXsvUBfRnvpSnGzacYwU=
X-Google-Smtp-Source: ABdhPJwthGTDK7Mm7CFwcUOKbOdXAe9So48JNYAFw4mvphdFmrDbFR2FvPe4HJsfTtqRakBAJff3IyTF7LbLcqFxOQg=
X-Received: by 2002:a9d:7dd4:: with SMTP id k20mr19635216otn.68.1630336170742;
 Mon, 30 Aug 2021 08:09:30 -0700 (PDT)
MIME-Version: 1.0
From:   John Spray <jcspray@gmail.com>
Date:   Mon, 30 Aug 2021 16:09:20 +0100
Message-ID: <CAJP3sOU0kuu5XbrqTv_L3QHTe6eywwxtr1xLw8sxdEYvXdTTjQ@mail.gmail.com>
Subject: Rust async bindings for rados
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

Earlier in the year I was having fun learning Rust, and one of the
things I did was to extend the existing ceph-rust crate with
async+streams support.  Rust's async stream support is very nice, and
makes writing small+fast gateway-like things quite low effort.

I'm not actively working on this any more but I've parked it in a PR
here for anyone who's interested
https://github.com/ceph/ceph-rust/pull/79 -- I thought I'd drop a note
to the list just in case it's of interest.

All the best,
John
