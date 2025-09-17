Return-Path: <ceph-devel+bounces-3631-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0BC5B7F8C5
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 15:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA670162D60
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 08:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F14307481;
	Wed, 17 Sep 2025 08:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="G3FMGJx1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB5306496
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 08:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758096447; cv=none; b=bqvsTvyTyNgnWV1SkX8aRXVClXG+duNhLUKwe9XlcxDkBsl9jbGuqioIPvtj++lxfRXO0KlFfM1DQTqHmDQktThDKo9uAMilh69QxxU+/wYVPQsq2JLFBQPKH9rAIPiTCpVYFcjPcUWmP/rMQGzHevHkdD7KwfoFB9LEq6hFXj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758096447; c=relaxed/simple;
	bh=ULxGPsy12in8xaB8XAAx/MHCql8yGg5+fg4U9QO6Oyk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qMaQG1Ac8ifP/p6HtOjcHmgtQJjIv1lZBN+l76v0/DZLueh9klw4WT3dIogVp8aIKCh/cqzXMjFq7g4Bc+LtDDXTrm5adQQvoVuRqhv0rpkDj67b04NvAVDg334u6jvFP6PDSUFvkza0gnbx81C3n3Tykrb6qV5pMO+tixdyRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=G3FMGJx1; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62f277546abso7512836a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 01:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758096442; x=1758701242; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DNRlI7ZexQlRn+KvWa3uWLIRDjuqm7xKDYy7L/4pZwc=;
        b=G3FMGJx1C5eaHzZpVZvpWhK9o4qOyPdtbYxmuvEvAZ5rSXLMnJ0QNEnDEO6PN7SLl3
         uBnDKrKt2nCrkiF882Z4SQdTopdI1ie0f6LHG4IjqRBGqR+3m/pFUbC3Z9jzwIzbri5B
         74BXEuVdWFtVRa5w3sFe3zhz7kqQeFsZebp+VW6L5efPqz06miAD/d3YEvv/pwfnyGnZ
         e1DBwI/18nzX9V9tKK/iRqVZHQqVK7aL2aYJpMu2xrUbZkFj0UlCqeWGIWFAWIeQXzYc
         xz7nGshy8yJ5rmGoq9/9ys7wYjo/ttnf7/8fmICG81Vi8Wfke6SK5loMyWjbHEJQOyED
         wvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758096442; x=1758701242;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNRlI7ZexQlRn+KvWa3uWLIRDjuqm7xKDYy7L/4pZwc=;
        b=L+EjiDqdqfBQAzf50VOejyDtcx5ec7MAnxvv1zVl+0eDHE8LTCRCq5PlYvvtxFZ+eF
         6t6RStvwFVQqwzWjemD3s3xwt/cu3Qargl4p7b+L2eqsgbaiyxoHni5clPs0/iof4ynf
         9VCPjXGI3hMzUF4ESmDLKXXb87RmoYlC2KwyIJAv3UX68z2g5YK9iH0/xPZ08mG7G+8z
         jtlNJHFqPAA6cpQFC/zhMI7AWOvWhSu1Ec62GWuoegCW99OgosXsFx4rWFmNpmaDikxV
         2lTP/HhipvUgpsgCMcdnGTZb9TQxq/iwDBqtsaJpMeuh4NkAZF4zPdcf6uUdQ3f1LGCS
         jqEA==
X-Forwarded-Encrypted: i=1; AJvYcCU6hvjL9sdm9XsEeLfciLRUYkBgll7KDZQgO8wsFLVY4HqVB6i1z7DtpfBr2R6gVV4HjzdFSeLGnbTI@vger.kernel.org
X-Gm-Message-State: AOJu0YzlUTLihuKLfLrSSgizEXmXKOZkmHpt2Z0YLqbRSHXfMSWQNFrD
	qZMusdKMg/UBKME/W3tBDJclsu6e8DQ4BJNUEjTaV0uGidMy3w//xTzf4uUmgiEP/thYM8vdot4
	8fnsl/4KUN9R5RZ8vOqoufm16IS+t3GMht9UZ6hcSML6cR8QJE0UtWyg=
X-Gm-Gg: ASbGnctqWCQ0wFi87Tu56fppbdUE2zCSP+9Ppbzu35XRHmTnHPfJ7Imbcg84FsntINz
	vdRQgWV74q1ozS0UBHq+w0J/3K9KL8KV4aFMEKZVU/7YOk9AS75P1uiu59qUR0XHH1QaVmkSt87
	sMe7Fyv4FEsnFCQN/DPDvKgm5Chvrnel0ojsvC32fbpl24T8kZIw3rt2bfdSC1qb5cWw8pxI2CJ
	on9pQltZLdxmdu237MGv9UZc37HBdIh6MGNlv5hoPQqx/ehr2+edEQ=
X-Google-Smtp-Source: AGHT+IGvGeJqz6Q02mqcKbNieydN4sypFy+amTH/8OFJSTbb1lWyRw+kypV83RI9Z/BsTyTx51m2zUmiLCU85daA7Dw=
X-Received: by 2002:a17:907:7b8c:b0:b04:48c5:352 with SMTP id
 a640c23a62f3a-b1bb5e56dc0mr141453966b.5.1758096442148; Wed, 17 Sep 2025
 01:07:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 10:07:11 +0200
X-Gm-Features: AS18NWBkDW9SAVDvoKJjAZoW5S3gl8FdSLNEHdMZ_rAESAoQoQ8-hAz_wKVvyLI
Message-ID: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
Subject: Need advice with iput() deadlock during writeback
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am currently hunting several deadlock bugs in the Ceph filesystem
that have been causing server downtimes repeatedly.

One of the deadlocks looks like this:

 INFO: task kworker/u777:6:1270802 blocked for more than 122 seconds.
       Not tainted 6.16.7-i1-es #773
 task:kworker/u777:6  state:D stack:0     pid:1270802 tgid:1270802
ppid:2      task_flags:0x4208060 flags:0x00004000
 Workqueue: writeback wb_workfn (flush-ceph-3)
 Call Trace:
  <TASK>
  __schedule+0x4ea/0x17d0
  schedule+0x1c/0xc0
  inode_wait_for_writeback+0x71/0xb0
  evict+0xcf/0x200
  ceph_put_wrbuffer_cap_refs+0xdd/0x220
  ceph_invalidate_folio+0x97/0xc0
  ceph_writepages_start+0x127b/0x14d0
  do_writepages+0xba/0x150
  __writeback_single_inode+0x34/0x290
  writeback_sb_inodes+0x203/0x470
  __writeback_inodes_wb+0x4c/0xe0
  wb_writeback+0x189/0x2b0
  wb_workfn+0x30b/0x3d0
  process_one_work+0x143/0x2b0

There's a writeback, and during that writeback, Ceph invokes iput()
releasing the last reference to that inode; iput() sees there's
pending writeback and waits for writeback to complete. But there's
nobody who will ever be able to finish writeback, because this is the
very thread that is supposed to finish writeback, so it's waiting for
itself.

It seems to me that iput() is a rather dangerous function because it
can easily block for a long time, and must never be called while
holding any lock. I wonder if all iput() callers are aware of this...

Anyway, I was wondering who is usually supposed to hold the inode
reference during writeback. If there is pending writeback, somebody
must still have a reference, or else the inode could have been evicted
before writeback even started - does that lead to UAF when writeback
actually happens?

One idea would be to postpone iput() calls to a workqueue to have it
in a different, safe context. Of course, that sounds overhead - and it
feels like a lousy kludge. There must be another way, a canonical
approach to avoiding this deadlock. I have a feeling that Ceph is
behaving weirdly, that Ceph is "holding it wrong".

I tried to trace ext4 writeback but found the inode reference counter
to be 1, the only reference being held by the dcache. But what if I
flush the dcache in the middle of writeback... I don't get it.

FS and MM experts - please help me understand how this is supposed to work.

Max

