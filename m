Return-Path: <ceph-devel+bounces-2860-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6A4A4F891
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 09:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25D191884E0D
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 08:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B94F1F582D;
	Wed,  5 Mar 2025 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eo8uCk0u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3651F4178
	for <ceph-devel@vger.kernel.org>; Wed,  5 Mar 2025 08:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741162728; cv=none; b=sqCsLlM3TWzk00yRvtR7+6mQHY9T/r6nI3aJJDTroXW0U2xOJ1bZzYxNxRpmbYJl9rtAIsVqqFsU9cmFDQHju73XKcYe0H0xiLFLhkbJ7I750TNJ2p15GP+QmEjTj25AWo+0HMtwipn3OZPT68OMeF57oMk7mdmqJpsRlwZZOf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741162728; c=relaxed/simple;
	bh=jn8/K2RnXixu8tyA1bxEEO6Dsz4gHGm9QWDyM+Os6hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYtAzINL1JPkmnmrxMO8zAMlyjMo8qhX5QSVSLnwWamsJOlvqB90pogXJVLffbOKQtni4/zBOjgCkV9eWR7SjRTS/7JmV1oDaOqJ4VxJVsHpcTohPljeehwlYiYMbAyUnMpXAQ2zp4t8bJLNda5ZoY6BVwzYgcN2tkjuxaN2Dow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eo8uCk0u; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43bccfa7b89so11639655e9.2
        for <ceph-devel@vger.kernel.org>; Wed, 05 Mar 2025 00:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741162725; x=1741767525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1Pfl+u2ap1W8Srn9iwmkKsR9Z81zakasExptX6WpvA=;
        b=eo8uCk0u1ZCET6Gh5UVi+PCl9qT6bywDWQ2f/7asgpePHX/E21rsqnZmap7zY9d8c4
         6Mokg7xFWNBcdT8ujXMth6t0Io6VaAXjnnlsKLJL764ZM79I/NTeKpYbGYd+8scVDgjn
         loml/MTpkFLBwKL7yoEkw0DxZoogYKX+SNJdTQHsSZyDUmOaEwOKvIhiyEfd+QIQz1iW
         lBSKEj+Oncj6JuETxYnwm+aJrkc/4x2KvSZ3v/Mbrl9LUiQvTrlqbTM7xC6WsZ9eNP2r
         6z3BvCZy+rw2mnyrBL91GHrJEgQem1e+4fxJUKcWWhkEyhXRmrBR+SxwfZzqQcuRHPnF
         EkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741162725; x=1741767525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1Pfl+u2ap1W8Srn9iwmkKsR9Z81zakasExptX6WpvA=;
        b=Eb8pFIyr1Nb9djI9/cQ5av7IwuMVqCsJXJYsg2Eryd7PmTaB5s5AaS17BWYq0UE5Du
         nW1aETEucKDYEnmQnMcnMLi1YVc2jylqc/bHqH7YHLSSccZMGTmv6G+06gsvGs/Zxg8G
         +4080ycz1FY0n4JWhhwd6A3sqaYGrokiypfNW4W35yQBqdKojT9VS2N/r4+ydaZjOTI2
         77VX13kiPOLlfYAuiezUb9Ovk6PiOdMxKr0Oc4nBNbbo3IvTtSeQYnpzpkdQbPr6Re5J
         e50WwamoZ9xRQBd4IstU69qIOpiyxIoIovGbJeG7ADd4oO6HsFcLAyK0KS48RzOHAroq
         dVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3PwKuMYv3kKG4PEAgijkluge5R2x8HJx1Im2KPrs79PdXy0SU7MJkariUxJQdao/+E2E7r1zHKUAm@vger.kernel.org
X-Gm-Message-State: AOJu0YyB8ruqWrxl2QDVSuoP4rwc/as6shA7MRgu2WeG0OPBveDlwi4D
	cnWgfBpcUT5M+NnQyrBAzerJF2F6NVygezSa8QNo/8WFzReF7tNpaolehDB7tMc=
X-Gm-Gg: ASbGncu1Z9I50s/UVIVLNNprH4SEikoCVTE1IyHonwmadJd09nE+N2w+Y56QhgQPYKe
	AjNEAzlbT676MSlVU6KJ1SKuS81XWN6PBgzyUIIE/Y5jBYwmjQedHgzl0l5RDCzHgy4E5AOLu7v
	L0ov6HioevriDjn6IsZ+KngQrgsKogOFa1D1nEwT3eDm47Rma1Sv1VHSPOLwDkhy1p5xQCR8yYq
	zvOxXPkVQM8Loo0xfi9yg4DACJfX8KFHFN9WQWfidhM/4NbWkHgaMM7tMsmDfzUnXwtPCNf5fIU
	oFdOfYT+oqAoqYMiYTiwT7KKv0pIqbWim1o/VcIPf9NLC5nQNw==
X-Google-Smtp-Source: AGHT+IHDuYxClcLocB8e9QcfuMaSWcwaSkRa35ZYikZGOgO4Oa+9XPsX/vrhDnizXQJD3HykkPAlEw==
X-Received: by 2002:a05:600c:511c:b0:43b:c0fa:f9cd with SMTP id 5b1f17b1804b1-43bd2972e1dmr13991125e9.7.1741162724670;
        Wed, 05 Mar 2025 00:18:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43bd42920a5sm9999785e9.11.2025.03.05.00.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 00:18:44 -0800 (PST)
Date: Wed, 5 Mar 2025 11:18:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ceph: Fix error handling in fill_readdir_cache()
Message-ID: <df103360-56b2-40f8-bc3e-d7b8a77be854@stanley.mountain>
References: <20250304154818.250757-1-willy@infradead.org>
 <7f2e7a8938775916fd926f9e7ff073d42f89108b.camel@ibm.com>
 <Z8fTOEerurzqKybx@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vqIsNXnQDFvGGJQM"
Content-Disposition: inline
In-Reply-To: <Z8fTOEerurzqKybx@casper.infradead.org>


--vqIsNXnQDFvGGJQM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2025 at 04:29:44AM +0000, Matthew Wilcox wrote:
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index c15970fa240f..6ac2bd555e86 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -1870,9 +1870,12 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
> > >  
> > >  		ctl->folio = __filemap_get_folio(&dir->i_data, pgoff,
> > >  				fgf, mapping_gfp_mask(&dir->i_data));
> > 
> > Could we expect to receive NULL here somehow? I assume we should receive valid
> > pointer or ERR_PTR always here.
> 
> There's no way to get a NULL pointer here.  __filemap_get_folio() always
> returns a valid folio or an ERR_PTR.
> 
> > > -		if (!ctl->folio) {
> > > +		if (IS_ERR(ctl->folio)) {
> > > +			int err = PTR_ERR(ctl->folio);
> > > +
> > > +			ctl->folio = NULL;
> > >  			ctl->index = -1;
> > > -			return idx == 0 ? -ENOMEM : 0;
> > > +			return idx == 0 ? err : 0;
> > >  		}
> > >  		/* reading/filling the cache are serialized by
> > >  		 * i_rwsem, no need to use folio lock */
> > 
> > But I prefer to check on NULL anyway, because we try to unlock the folio here:
> > 
> > 		/* reading/filling the cache are serialized by
> > 		 * i_rwsem, no need to use folio lock */
> > 		folio_unlock(ctl->folio);
> > 
> > And absence of check on NULL makes me slightly nervous. :)
> 
> We'd get a very visible and obvious splat if we did!  But we make this
> assumption all over the VFS and in other filesystems.  There's no need
> to be more cautious in ceph than in other places.

Yeah.  When a function returns both error pointers and NULL that is
a specific thing.

https://staticthinking.wordpress.com/2022/08/01/mixing-error-pointers-and-null/

Adding pointless NULL checks is confusing and only leads to philosophical
debates about whether the future code which adds a NULL is more likely to
be a success path or a failure path.  There is no good answer.

I have a static checker warning for when people accidentally check for
IS_ERR() instead of NULL or when a function can return both but we
only check for error pointers.  But it turns out that I needed to update
it and also I hadn't published it.  I'll test the updated version
tonight and publish it later this week.  Attached.

regards,
dan carpenter


--vqIsNXnQDFvGGJQM
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="check_no_null_check_on_mixed.c"

/*
 * Copyright (C) 2018 Oracle.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see http://www.gnu.org/copyleft/gpl.txt
 */

#include "smatch.h"
#include "smatch_slist.h"
#include "smatch_extra.h"

static int my_id;

STATE(null);

static void deref_hook(struct expression *expr)
{
	struct smatch_state *estate;
	struct sm_state *sm;
	char *name;

	sm = get_sm_state_expr(my_id, expr);
	if (!sm || !slist_has_state(sm->possible, &null))
		return;
	if (implied_not_equal(expr, 0))
		return;
	estate = get_state_expr(SMATCH_EXTRA, expr);
	if (estate_is_empty(estate))
		return;

	name = expr_to_str(expr);
	sm_msg("warn: '%s' can also be NULL", name);
	free_string(name);
}

static void match_condition(struct expression *expr)
{
	struct data_range *drange;
	struct expression *arg;
	struct sm_state *sm, *tmp;

	expr = strip_expr(expr);
	if (expr->type != EXPR_CALL)
		return;
	if (!sym_name_is("IS_ERR", expr->fn))
		return;

	arg = get_argument_from_call_expr(expr->args, 0);
	arg = strip_expr(arg);

	if (!arg || implied_not_equal(arg, 0))
		return;

	sm = get_sm_state_expr(SMATCH_EXTRA, arg);
	if (!sm)
		return;

	FOR_EACH_PTR(sm->possible, tmp) {
		if (!estate_rl(tmp->state))
			continue;
		drange = first_ptr_list((struct ptr_list *)estate_rl(tmp->state));
		if (drange->min.value == 0 && drange->max.value == 0)
			goto has_null;
	} END_FOR_EACH_PTR(tmp);

	return;

has_null:
	set_true_false_states_expr(my_id, arg, NULL, &null);
}

void check_no_null_check_on_mixed(int id)
{
	my_id = id;

	if (option_project != PROJ_KERNEL)
		return;

	add_hook(&match_condition, CONDITION_HOOK);
	add_modification_hook(my_id, &set_undefined);
	add_dereference_hook(&deref_hook);
}

--vqIsNXnQDFvGGJQM--

