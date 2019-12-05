Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E56113A38
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 04:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfLEDJq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 22:09:46 -0500
Received: from mail-ua1-f42.google.com ([209.85.222.42]:43742 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEDJq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 22:09:46 -0500
Received: by mail-ua1-f42.google.com with SMTP id o42so679840uad.10
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2019 19:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UwDkFYwAzVJJ6pvABOQ1f420z5wwO/OafzsDYee4x+E=;
        b=Ga+vlXxQGXPjwydMykWL+Q5pvRKrfmClfGWXYIwMuL14P8DBYULuEnmconcCqEn+98
         Fa7dd5PaWI80TtzYSESmpaCQYSJF9BJ+/B3QUQ02+obBBRWJI+YYGBd8Afr1OaMs56vc
         oSebDOv95/66Xpp02FotN/OGl2AWOBNxcYRU6/xPA8N1kMC26ojPMldK9yHxxl8bdwqo
         fgKQSObiXOqMDT7WkeJhjlExwL1zi303Aj5dVfjGt4d0nvEN3W0BnEe7zv36PRLLHTEm
         Ah7Rv8AhJoeIaZ+NqY6X8Qdw1fPInmJVqZhnrvPWraWf9otzY6WOUy236eUaTbn3eCV4
         Yz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UwDkFYwAzVJJ6pvABOQ1f420z5wwO/OafzsDYee4x+E=;
        b=Vr1k6u9IamUBJobPphNCYHfonSAHqjAoXcUyYWxYg/77UPKVRBT6ZjFCHE+eIsh1X7
         7QaHbCT4W/gPOPB6QYB4WWp9bUEhX6SXjapaiqVuyUlsT41lhNLQ9rjS0Bp7+MJTHtY4
         i1U8jXG0zUTZU/uFtpCL0HFTpPZDJidm2MHVcmW4XSvnw4QltFElNnEpb97JaKkt4UBf
         FiM7o+09o9KSti7MsLItC6++oEOLxeIaSAKkt39g03qZjnnWYUpT9WQicKLEICM/8clU
         fInAhtBiKB0SE0Iov1o8vlNrPKCTqdz3lm5apaK0flDXDQ1l/yMqm0AYXOxyYgONbnN6
         WXpg==
X-Gm-Message-State: APjAAAX1AeS5Wx7P0Ho6UjAKt/5i4F44lELlTr31BrUtVGOr3AWz2O/i
        JaYr2PtyuLPGvAaoLUc6E/dbMY3kr5vbjeWDWoEg5Hok
X-Google-Smtp-Source: APXvYqzeX3Oypp/ANA9v35KCwle4yVphzpbCc6iBntTV2rv78e6gA2SuFrRrGh9NYoTiaWXTI7GOysKduUe8dz4YD8w=
X-Received: by 2002:ab0:1492:: with SMTP id d18mr5245151uae.0.1575515385496;
 Wed, 04 Dec 2019 19:09:45 -0800 (PST)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 5 Dec 2019 11:09:34 +0800
Message-ID: <CAPy+zYU4TCxitLwgDqQF_7BhX9b9=vcu0YDD0XyxN1z2iEXPaQ@mail.gmail.com>
Subject: lease_cr memory release
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi cephers,
I have a question=E3=80=82
in class RGWMetaSyncShardCR
boost::intrusive_ptr<RGWContinuousLeaseCR> lease_cr;
lease_cr Reference count added 2 times
the one is  lease_cr.reset(new RGWContinuousLeaseCR(....));the other
is  lease_stack.reset(spawn(lease_cr.get(), false));
but lease_cr Reference count subtracted  1 times    That is op->put()
when op done .So I want to know where the other op - > put is=EF=BC=9F
I add assert() in  RGWContinuousLeaseCR Deconstruction find
stack:
 1: (()+0x5c9562) [0x53f4562]
 2: (()+0xf370) [0xf182370]
 3: (gsignal()+0x37) [0xfae71d7]
 4: (abort()+0x148) [0xfae88c8]
 5: (()+0x2e146) [0xfae0146]
 6: (()+0x2e1f2) [0xfae01f2]
 7: (RGWContinuousLeaseCR::~RGWContinuousLeaseCR()+0x7e) [0x513b69e]
 8: (RGWContinuousLeaseCR::~RGWContinuousLeaseCR()+0x9) [0x513b739]
 9: (RefCountedObject::put()+0xe5) [0x5139185]
 10: (RGWMetaSyncShardCR::~RGWMetaSyncShardCR()+0x95) [0x51e1775]
 11: (RGWMetaSyncShardCR::~RGWMetaSyncShardCR()+0x9) [0x51e18d9]
 12: (RefCountedObject::put()+0xe5) [0x5139185]
 13: (RGWBackoffControlCR::operate()+0x115) [0x51cc715]
 14: (RGWCoroutinesStack::operate(RGWCoroutinesEnv*)+0x73) [0x5134943]
 15: (RGWCoroutinesManager::run(std::list<RGWCoroutinesStack*,
std::allocator<RGWCoroutinesStack*> >&)+0x3bc) [0x513788c]
 16: (RGWCoroutinesManager::run(RGWCoroutine*)+0x5d) [0x513840d]
 17: (RGWRemoteMetaLog::run_sync()+0x108a) [0x51d3f2a]
 18: (RGWMetaSyncProcessorThread::process()+0xd) [0x52d662d]
 19: (RGWRadosThread::Worker::entry()+0x11b) [0x52787bb]
 20: (()+0x7dc5) [0xf17adc5]
 21: (clone()+0x6d) [0xfba973d]
I don't understand it ,because ~RGWMetaSyncShardCR() doesn't call
RGWContinuousLeaseCR->put().
code:
~RGWMetaSyncShardCR() override {
delete marker_tracker;
if (lease_cr) {
lease_cr->abort();
}
}

can you help me!
Thanks.
