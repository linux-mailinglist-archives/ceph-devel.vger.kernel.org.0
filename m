Return-Path: <ceph-devel+bounces-1990-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA889B4568
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Oct 2024 10:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91193B2129C
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Oct 2024 09:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4ED20403D;
	Tue, 29 Oct 2024 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxSHTF8l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1B204035
	for <ceph-devel@vger.kernel.org>; Tue, 29 Oct 2024 09:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193220; cv=none; b=qt6XWk8XDyjrDk5lg4MTVDjgVZa6liKOs9vwJneX29naTi+9QpY2MY0i+IMJikBxzEIwcgM23bRoyx7DP7FLk1r+R5HunywfvIYI272sEggZio+p0VZRM6WJfr/obLevdtMa20CoXP16QUbwSt8dj3VqVeKHMmDPvB383d7TBOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193220; c=relaxed/simple;
	bh=OInM8fY43RJr6VspN2OqvqWKSSTabvtUO50Phh9bf6E=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PZcrWTBhIJr+FjO46ym8oxKXKjMjwaAMOrzuV+EfHoR+0QA9jAKQ3DDQY3QkO3Q4J8E9etM+UI+fKlMGzNfqYMGbFflLCNb6NmfgTLwD/r4/gSbZLG4X/AXSHWsdxtQKQNqfnV2sBefPD3NSrUBW72JWJdeL+xUT9b4UpvEMj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxSHTF8l; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37ed3bd6114so3347078f8f.2
        for <ceph-devel@vger.kernel.org>; Tue, 29 Oct 2024 02:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730193217; x=1730798017; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OInM8fY43RJr6VspN2OqvqWKSSTabvtUO50Phh9bf6E=;
        b=bxSHTF8lb8ttlw/jDd2eEAdRudN1Gf5tIe62iINDEc5u0IEh1hMZ8Q9lUcK0+tgaCH
         fir86rw1GMP1TWl30jC73VTX98kAMpSs6HlnYpMLbG3kjMXCAS9GlRDfKlzDndXXjd7N
         4KwuabzWdSV1UBr3b/HWSdj4+0A2eMcxbeUuiGvgp+o9MugrsoDHvLFY67mewuncBF18
         AohQPT8v/9bLrfjIVuGcYimSnU07LCDQv0i63uzbcnNcZG6aQwCs5UtYjPaZNIuNZTMc
         JHxMs+JYfDGRPkSrS1yn94I7/ELb19G/DT6P83JrYQoKj21ScZ4N9KPfNkYococGMhCP
         kmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730193217; x=1730798017;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OInM8fY43RJr6VspN2OqvqWKSSTabvtUO50Phh9bf6E=;
        b=chatgpriAmw4AtU+f4p3vT34iatcX6zTdlwXSQo2bmw+obEj1OprDnh1QBX2Ccajv1
         /FIvSwwfrqA6J2aeOf5fp8kT3DRPc8H9UKlE1UUXXrpCOhL6MwQ3hcGZ5bnSF55n73+4
         Vm6wJNUJUU2x9mSTjw+cjO8VAFaqBi7/0EgoXcRTEIRTj3Uyt2cv4qKsidnjVKjvysx+
         j5IgV0yHFgXQpZTr2bw5k69dUOR3dm8so90d/L9UbUcWXettX3EuCz6xIjqMt14iSACr
         YvmvF9VxdcdDfx1rgQf+Mu7PRWaAjLBTcNFGLPdFnmma9tn2R1QwQcOLEiv3DoGmPdB0
         HRXQ==
X-Gm-Message-State: AOJu0YxlwjNvFP1BJPD+qF2YjRcvd81DuAiTw0d6e5LZk43MMswd2GRM
	6I9fAq5PT/2Q/WAFbE4GvytAmQjFbHue/oPMxVppPEfuwiy3+d1TlJWVrCB9fBvFnYjHGPtTB0r
	sxkd/rwvwMLFKGXbWx8EE21/pp04IU/WA
X-Google-Smtp-Source: AGHT+IEh5fOwZm7MP8VBSMVgxW2aiiY1IOyCLwjxMZNxouoBl8qrU/975VbjedISxg+HxzqtoKqz26vWLolQEBsfpDE=
X-Received: by 2002:a5d:6302:0:b0:374:ca43:cda5 with SMTP id
 ffacd0b85a97d-38061004bffmr8457562f8f.0.1730193216701; Tue, 29 Oct 2024
 02:13:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: tzuchieh wu <ethan198912@gmail.com>
Date: Tue, 29 Oct 2024 17:13:25 +0800
Message-ID: <CACKp3f=17HPw=aB1Di455buZriGTbErzu4ZVe48EK+vRNcTEdw@mail.gmail.com>
Subject: Calling iput inside OSD dispatcher thread might cause deadlock?
To: ceph-devel@vger.kernel.org
Cc: ethanwu@synology.com
Content-Type: text/plain; charset="UTF-8"

Hi,
Recently I was running into a hung task on kernel client.
After investigating the environment, I think there might be a deadlock
caused by calling iput inside OSD dispatch(ceph-msgr) thread

My kernel cpeh client version is 5.15
The call stack for the kernel ceph-msgr thread is:

[<0>] wait_on_page_bit_common+0x106/0x300
[<0>] truncate_inode_pages_range+0x381/0x6a0
[<0>] ceph_evict_inode+0x4a/0x200 [ceph]
[<0>] evict+0xc6/0x190
[<0>] ceph_put_wrbuffer_cap_refs+0xdf/0x1d0 [ceph]
[<0>] writepages_finish+0x2c4/0x440 [ceph]
[<0>] handle_reply+0x5be/0x6d0 [libceph]
[<0>] dispatch+0x49/0xa60 [libceph]
[<0>] ceph_con_workfn+0x10fa/0x24b0 [libceph]
[<0>] worker_run_work+0xb8/0xd0
[<0>] process_one_work+0x1d3/0x3c0
[<0>] worker_thread+0x4d/0x3e0
[<0>] kthread+0x12d/0x150
[<0>] ret_from_fork+0x1f/0x30

And the following messages are from osdc in ceph debugfs

2774296 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x40002c 92 write
...
2774578 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774579 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774580 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774581 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774582 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774583 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
2774584 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
200006dabea.00000003 0x400014 1 read
...

We can see that kernel client has sent both write and multiple read
requests on object 200006dabea.00000003.
The iput_final waits for truncate_inode_pages_range to finish which in
turn waits for page bit.
From the above osdc and taking a look the code, I think
truncate_inode_pages_range might be waiting for readahead request to
finish.
The client cannot handle the readahead request from osd since the
ceph-msgr itself is blocking on handle_reply, however.

This following patch solved the problem by calling iput at a different thread
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/ceph/inode.c?id=3e1d0452edceebb903d23db53201013c940bf000
but was reverted later because session mutex is no longer held when
calling iput.

In the comment of the above patch, it also points out:

truncate_inode_pages_range() waits for readahead pages and
In general, it's not good to call iput_final() inside MDS/OSD dispatch
threads or while holding any mutex.

Therefore, it looks like calling iput inside OSD dispatch thread is not safe.
Any suggestion on this issue?

thanks,
ethan

