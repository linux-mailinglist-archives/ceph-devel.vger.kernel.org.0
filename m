Return-Path: <ceph-devel+bounces-1987-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4880D9B2085
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A90B281368
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC96517BB25;
	Sun, 27 Oct 2024 20:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="PhwJgdLH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7320291E;
	Sun, 27 Oct 2024 20:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730061927; cv=none; b=jqaqs7Gzhak3AyOoeO+miZuMj5vBghT52OlkSM11hy5bSXwpzjHpopMP8xm//x61FFw70do1IgJxiFN8KPEuuEqm02G34iLWVtzGSCVR144+/QBf3Faa5ouyRmYrsyZftWT4RByA33J7daDsuLmysS+V7h0BDBV07LIFxQeHDgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730061927; c=relaxed/simple;
	bh=9zXBIR4jK8F+z64bb1NP+JrpvanmQ0CF4s7/ZrMfyJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3iJHNTDbgSo6Ba5NlL1J9OnSBXl1HkAEkWzClXQgVHThg8GY9tC41HQ7qljcR7oddcQKG5hqEsUxUYqVyC4XBeG9jtNshxDpldStnaFez2TiLOoSJeUXcd6ihr41bUMC8P1YOzreFRUtMQfH0+2yloaPWOnKdqA5cGywCM7sJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=PhwJgdLH; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=PHzoQUxl50rm6D8h04ALz6ZmPdJ+g0LyRyAMK0/9l+4=; b=PhwJgdLH6Pul4/9D
	BoGu8yjY7yNTMErvDcdNhXTD9jYnYZs0f7oFDR3dNZAQ7ZmAn7B/mov2rhGQA07BktX27+ZQWL9x/
	2/FEkCxnD2PI21tkjuH88ZCgFGgOo/YtycKTVDaTFthxy4madOunQ4JAWT6F6FSNwA/b5yW0Kk8vQ
	rE9MLs6dgQ92ubhD868AWrWeDrt6to7SUo/1PPk+kz0CBilu8uCR9KEbEYLGEtJ1ytYWUtI+PBYFY
	/+rhOabRsrJ4LcgWOwVQH+vj/KWjBgPk+g7J21TXKJ54JD3TsycHqGgx7XE+QW05lUWNDMSnGL0DK
	dIa1gZnVi/1FizwA7Q==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t5A8X-00DoO7-24;
	Sun, 27 Oct 2024 20:45:21 +0000
Date: Sun, 27 Oct 2024 20:45:21 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Ceph deadcoding
Message-ID: <Zx6mYTxz0V3LscOW@gallifrey>
References: <20241006011956.373622-1-linux@treblig.org>
 <CAOi1vP8PaYSZCoWHkNFfSQyb2n0qc4pB7iJRrMpJ+9Ck9=UHdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8PaYSZCoWHkNFfSQyb2n0qc4pB7iJRrMpJ+9Ck9=UHdg@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 20:44:49 up 172 days,  7:58,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Ilya Dryomov (idryomov@gmail.com) wrote:
> On Sun, Oct 6, 2024 at 3:19 AM <linux@treblig.org> wrote:
> >
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> >
> > Hi,
> >   This series is a set of deadcoding in fs/ceph and net/ceph.
> > It's strictly function deletion so should have no change
> > in behaviour.
> >
> > (get_maintainer was suggesting the netdev team as well
> > as ceph? Is that correct???)
> 
> Hi David,
> 
> No, it's not correct.  It's probably caused by
> 
> F:    net/
> 
> entry in "NETWORKING [GENERAL]" section.  I don't recall
> get_maintainer.pl doing that in the past, but I could be wrong.

THanks, I didn't think it was right.

> Anyway, I'll send a patch to exclude net/ceph there.

Thanks, and thanks for applying the cleanup.

Dave

> Thanks,
> 
>                 Ilya
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

