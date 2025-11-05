Return-Path: <ceph-devel+bounces-3923-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20568C34011
	for <lists+ceph-devel@lfdr.de>; Wed, 05 Nov 2025 06:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94D45421CDF
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Nov 2025 05:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430FC26F29C;
	Wed,  5 Nov 2025 05:48:06 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F126CE17
	for <ceph-devel@vger.kernel.org>; Wed,  5 Nov 2025 05:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762321686; cv=none; b=BQPiQcZsZcOwd2ikFTa8cGRaR4ouS71LnohShARs65xfzHrbfEJcfuN2w1GS7pVGHbfdx7NsGKbTZoa3Y2k++yk1/sjK6nwgNU37mVbyZKTcoM1qwfVlV2izPIgiaUGZsGI73sbBlPxUiLhBho/FNyH51n/qZbnblOTcV2iR2LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762321686; c=relaxed/simple;
	bh=GlQIhOpVt8G+BVYMy665LNIo97/TwQy9Ja+ALJ1AUDo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=W+yNlQlJBJEHCrZPbY14ZEHesQEzzKscR1QSqAZnVw6TmZa8Rj1PtFW2G44UQOxBjRg145GDpp1CxZhrN8Qtbx24D9CxksEjQncInGv19x0BJM23M7Zgvl0JqEB2gtv31lgK2T4LEZqUKWbduCqE35luYOd6cXB5H67oZ8eET20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-93e7b0584c9so534844839f.0
        for <ceph-devel@vger.kernel.org>; Tue, 04 Nov 2025 21:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762321683; x=1762926483;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4XDLXqrEs29g4qhc4+ZUYTByJ5LUyYE6CBWzXLnGEU=;
        b=iq7GqPJqC8FYmknPxUzK872KauV3LhXlGyTcSteCqw29dp0LjcHMCcKfZs+BByVvdL
         M0OLiaPQ1XfHPpOotnQtLTonpZlbS+eqwXIPXI1lj9kymIvlMmEsPgPtBsvC2x423auM
         nmcKG7qqiFzEank4/EKDe4nW3a35NXnZUntKn1S00mlkGJ9/a8W07Eq/75FIJGMg1Y1A
         MdoFFZ6HJ6YAhTiDw5h9UtqyAQ5tGi6uc2UwhgT0ZiihkLdDQmGZ9ahRXx07mgQOauBT
         AQGHmJQW8Ei6AhiAmlPHlNxX219os63qKqS40lAK4qUTKyb0OENeJCVPAbKDHZFxTVnD
         SZGA==
X-Forwarded-Encrypted: i=1; AJvYcCVko4xBcTAKwzG8yljkn1b3tyFbVZEKZxDVZXYiumQ4bZaVNK4l9YuVsfUdBIL9XdCdTC/vdF6lzjE2@vger.kernel.org
X-Gm-Message-State: AOJu0YwPfA2vv1nCKEmXXaneRz2ku/ssDKNqAAVIH1fWOkepMYGAugcv
	9m0E8/gbNjlb9kGTM78Mwd9pgA/mZeW2Yi6OLtiRuc7x+M06CZbnbOOOyiv2BCWZk0xm3kHHkh1
	QuE6h30IRIqRFqOxR9ohrVjyDcl+2TUcQWv+lt9L/EEKdibkA7yoaweZJwaU=
X-Google-Smtp-Source: AGHT+IFp+75P9fzMNP6tFwZqfyhcKVqnVaql1CMi2hGDeHUR9fDxpaS8IRIyJ/54rHYeSSnjNRL0DzJ+OpUzQhVJDknW+FXvnEk4
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29c9:b0:945:9f2d:592f with SMTP id
 ca18e2360f4ac-94869ebc957mr295259839f.17.1762321683439; Tue, 04 Nov 2025
 21:48:03 -0800 (PST)
Date: Tue, 04 Nov 2025 21:48:03 -0800
In-Reply-To: <68132c08.050a0220.14dd7d.0007.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690ae513.050a0220.baf87.0009.GAE@google.com>
Subject: Re: [syzbot] [nfs?] [netfs?] INFO: task hung in anon_pipe_write
From: syzbot <syzbot+ef2c1c404cbcbcc66453@syzkaller.appspotmail.com>
To: asmadeus@codewreck.org, brauner@kernel.org, ceph-devel@vger.kernel.org, 
	dhowells@redhat.com, ericvh@kernel.org, idryomov@gmail.com, jack@suse.cz, 
	jlayton@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux_oss@crudebyte.com, lucho@ionkov.net, 
	m@maowtm.org, mathieu.desnoyers@efficios.com, mhiramat@kernel.org, 
	netfs@lists.linux.dev, rostedt@goodmis.org, syzkaller-bugs@googlegroups.com, 
	v9fs@lists.linux.dev, viro@zeniv.linux.org.uk, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 290434474c332a2ba9c8499fe699c7f2e1153280
Author: Tingmao Wang <m@maowtm.org>
Date:   Sun Apr 6 16:18:42 2025 +0000

    fs/9p: Refresh metadata in d_revalidate for uncached mode too

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10be532f980000
start commit:   5bc1018675ec Merge tag 'pci-v6.15-fixes-3' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f5bd2a76d9d0b4e
dashboard link: https://syzkaller.appspot.com/bug?extid=ef2c1c404cbcbcc66453
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15631270580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a0b0d4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs/9p: Refresh metadata in d_revalidate for uncached mode too

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

