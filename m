Return-Path: <ceph-devel+bounces-2074-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC6F9C7CB5
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 21:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F55A1F21A3A
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 20:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B3517BEC7;
	Wed, 13 Nov 2024 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=myyahoo.com header.i=@myyahoo.com header.b="T5K9yH5Q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from sonic312-20.consmr.mail.sg3.yahoo.com (sonic312-20.consmr.mail.sg3.yahoo.com [106.10.244.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240AB1442F3
	for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2024 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.244.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731528953; cv=none; b=kuPQqw0tNSBKfzihrNK5KAE4EdI5UwABZuhbCmhzJUPWicSfGJs46uWCw9JL+Xx7RYb/9078jazPBPZeEAAm/OskGbraF2pHxvEn81MuD5QxOfDlz8TYae6kzPmzeFWa38GH9nhaFN5F1XWD7A19etjWk5WEcMSRgNa+GmxYs6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731528953; c=relaxed/simple;
	bh=Yv3ptKdLEwQGel+r075biMutE2FNylghIJrzYRKibkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKP5hq3Tj7+WcrmJU5x7BKApkwXu1i7omAFFm9CfqWWL+AKEwBojJm+So+8ZdF57RjQQzdJFHCACdzu/arb49msvU8k8PCXkx2jKPavFzEXFqWJCm4t9uZyn74NzCNZ9d7iAB/RTdhIlm9uhlN66mYHQPB5k0cHRr++/E/GNHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=myyahoo.com; spf=pass smtp.mailfrom=myyahoo.com; dkim=pass (2048-bit key) header.d=myyahoo.com header.i=@myyahoo.com header.b=T5K9yH5Q; arc=none smtp.client-ip=106.10.244.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=myyahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=myyahoo.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=myyahoo.com; s=s2048; t=1731528943; bh=beyMROixDhnL0DdVaybfjGhLGJmyzSqp34H2SyKrlBE=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject:Reply-To; b=T5K9yH5Qa2Vpy/6885+JikB9pl3XzUMvpelkJKYwXMwab0XNL84AlxZjfvZIMES1eesNPMS6LI2IWBK5VEtT/H5zli5yfxtyQ2lMtMj+1RP9cdJpTaz+3EnVAdcZH2s8zMOdJrBk9sGTq6ec0x89EUEhsWHsVnf+B/tEYicfidcbClGD8kXzbpMl+KpYXsrs2MClGRnLRue7coRZmURrsX59aXpOMvHCWZRi9U6s9Nwx5pnj8K/b+TnhtXukM3ZdtsyZZU26zclAj6bQIcQaOG+fcsefjOHzJMmwXlOSW2O8wf4pS0N5mebgR4I4hBHYdMryQ9OjPdIxKDL/QoIpww==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1731528943; bh=7BkUlhNlWdROeg/t4VTpA8NV7QZPKujHIJEgIZgO5fK=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=CVAsU+HAVgf8j+25cxzy3BQFsiJk9RkbPQKI0KB2anJeAlowqecwdstpyOKItyaaJMIVTehqTQL85Osw/LxBLTqSAifn1yHLEQFaxK10XcwOHreC3yN4c8vcPEErq/dqA1h2mt1P18kBdgpVK4s8RXXS1g+B95ZLaPrfk4FpS6ZH2lope8MEDpKG3NZyYPE205tXZUqtew45VIxjv7TsJ4TbG0NpY4JUWZTzI6XcRDAGfDX9E8nqXfOrUXQ9xsNQKl6iqnrv2M1Y/Mtbg/Z1SwAKl9fVSmtw4uZIY//v5l7+/N1jB2zncVF5RUnEjq+WsAoXa8hdWh0+t4lNoYnbdw==
X-YMail-OSG: j4YlkUYVM1lPxTS82WrUwVGeJ5E.xjG..XSKQyNUS.Fn8ov9kxCk50AT5kZ4Wo3
 u8bYRPJcIaGL..aiOimu1BKsAhBdCSXEDXdDKsVhX0aJuJxy1C8ffKxb0mUWrNg0jzeNsnfy.r.n
 bxhCB3QHsFRuaPkcnGd.02ZrpfsibxIlCURhKxaQDkU2xXdyxZF0x3cmJYWVVyVse2S0Murm1PIL
 qDXAlpFC3xTc1eIQmXUEs4bFfPzAS6mJDRs3wJSdximX0UtM_JWWMp3J33GBx7iLwPh.qDo9Q9pR
 zNBTHlphy_lRTyBx0yad1n4aK5vx1sf1257RBrwu9hV4dshMEeodZ6oTl_PavAwm5mZxvgFmMTZ.
 ka1_MdfKMm26YyTtPf_WW5wY5z49nXdisyJ2IOr5V0aoAjybPtzNeq.Gtu3iZlfMAj3f41VrUjVg
 R9X3ChGX_3pnrdVDyEfIr8zzlUTvufg_EWmbbiMXx9npgoBz1YCJEE5WtLyNhl31l3v4uN9hZpuI
 UMRTuh_DXotm6wUermt6RhcTs1NHT75YJuGWOnrYkf8J04gE4NoUPS3DkZVmmLv3RAngiNr8vwsy
 aVrEXQ7_PSRJwkCoRsOLahgJ0N.p60NVi2Gt6QBlzVNfJeeVUtSxy5h5qVVJGF2EnnADh1IRLvo4
 PW4B3xZH_GsHgGJu_UZioRP8o7zoELi08PE8q8QlYvbaoWMBQEqEuZwSC2SJ5szeVwnlrSmSc3gF
 7aGrTr02Je5WqGugmPofgGBRSaehbjgJFdqynyuQ1YRDcpcmLUqXyzbk3sIZn_moDyjH_ph4veDz
 fe.3pEhnmJdxFFvfnSsAIOcVLmuxKRCLR2XzvEKTU1gDNIWmDISqnPDZUtVId1oeF9sug_YRJL23
 3QZ2a4cV5rMcZjWE5zgLcylh7n3oAMGT2uSnQTpOg7WmOUXk34sCSdzCl22QmMqZH.r54IG1qtot
 Zh3PljRaTYhXKQKiFemM0DYvQBZTSOhPiWL6S.3YjcWPQUNQZyZE5pEL6Wwi.mH1TUMv1K4FP7Wn
 FG6ZzOJjuR1hx3gPhQkyCKZ5mMmB7_o9wXP0Q5fTydDKuxyxlCgggw_hWzureKg7qxLBfdSK.XFZ
 oqgLFR1D9LzzeO3mWhCGWNRsOZy2kpwnbufUtngo4s2VRpElNNB09PRs4NWIneA2iDTyLfF1fdmh
 QMP5rdo9wtdD8mnmagB0EN4fdWLICU2LoI51hflBrACfgEbqDnl_vSLcpHv_0BF_IqMG3M4.FV9Y
 R3pxy8NVZedgbMDJiyGgXny.o3hqsBtMN8.C2PgqhIIFHhpzX06f6oHlCYJ7ggf3jpGl71i6N_EP
 JxY8ZjNg8CjodivaH1P2MewI_7e7ogZWIhUHco27kbxCYDaHDh8Rh3Rct65_RKC3Z3gztqBSEVhK
 NylAng.KkoedJEGg3CqJ9ucDEybhD5GdD.gg5MByg0YvNCPrOhNAWkEOFlUNwcqjOh1URDdN67ED
 qf5iy6fnFWaPQL.pihw2FEi3TVZPmP1_PfGsgPLLIiE3B3mOPyo4AT1LerPl_jNnDpteLJ8bWt6P
 6D.7PCzTqukIbH1Sjdi.nG0CO.qPJYj6TckS._D1oz3kzeW4UCJuWrTYpeIIKla0IXPNajGlA3PL
 3hCjIEl75EJmG5w3sbtqzRljrPDLZ307NQhL4txZ1jFVtsMGUdCG9WjURTZOtO_4s9dyYmBxilyy
 zJIblZodf70kJt2iZv5ZHvVPNphDpbmpRXD1KLsQkzoU3hshbBEB2xYvsNI1O3J8NR5r57pvDegk
 c5ob1NHGVD6yF7WOgpLB20E6.lH7bcKQ4REgXepfHgosOzKF2oWf7dgy6MWVYuCDe2szqI9Fl4Q8
 pOtfSY5ZwG9HAP3fiWnS2Gj3pgZ3vAS5qQZqzgsarIjJ112FKhit7ddBy5CyG8qvtNl3qv4k0vO5
 7AThxJybRyWV3SbrSGhPADshglj4eQ3maAjFSfB56WvA_.7X.Jd8LirNVDkgWw0qrkSB.TQ_5dQe
 m3VzyF5tJfZo2HGGRwIzkMyE5r2rg6q74zY1fWRhLdWtHXXSBaUD_v2dhfyhDbsNCZHa8ocoGylX
 VQpEMlZsUw0T.7AuA.JBYBUst.AcJ2L_bf6YJvYIqHDouwtlF1KPL8t4iR8QgkL86ylN6XHzrWYI
 avyexg9GYafPqk7dREQp7hmSGj.V8LLCUxShbu6rLTbmWlgae__RyW5jauAhndQcQtxRyBOGOS3B
 QpBAjqb6rMR8fwLEd3UkDlQr5G4MSFsI-
X-Sonic-MF: <abdul.rahim@myyahoo.com>
X-Sonic-ID: 6c3f9df7-3f61-4b16-aa46-bb221d09a195
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.sg3.yahoo.com with HTTP; Wed, 13 Nov 2024 20:15:43 +0000
Received: by hermes--production-sg3-5b7954b588-7n7t7 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6e35b61bd0fa8f5014433ff06e4d5859;
          Wed, 13 Nov 2024 20:15:38 +0000 (UTC)
Date: Thu, 14 Nov 2024 01:45:35 +0530
From: Abdul Rahim <abdul.rahim@myyahoo.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use strscpy() instead of strcpy()
Message-ID: <o6dz6grwkknan6er5lig6i37ocfekn6i3fljltptn7aol45sfl@n5amdhwr7wmt>
References: <20241111221037.92853-1-abdul.rahim.ref@myyahoo.com>
 <20241111221037.92853-1-abdul.rahim@myyahoo.com>
 <8fef8eab-cd82-4e05-ad9b-1bb8b5fe974b@wanadoo.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fef8eab-cd82-4e05-ad9b-1bb8b5fe974b@wanadoo.fr>
X-Mailer: WebService/1.1.22876 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On Tue, Nov 12, 2024 at 07:21:54AM +0100, Christophe JAILLET wrote:
> Le 11/11/2024 � 23:10, Abdul Rahim a �crit�:
> > strcpy() is generally considered unsafe and use of strscpy() is
> > recommended [1]
> > 
> > this fixes checkpatch warning:
> >      WARNING: Prefer strscpy over strcpy
> > 
> > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
> > Signed-off-by: Abdul Rahim <abdul.rahim@myyahoo.com>
> > ---
> >   fs/ceph/export.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 44451749c544..0e5b3c7b3756 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -452,7 +452,7 @@ static int __get_snap_name(struct dentry *parent, char *name,
> >   		goto out;
> >   	if (ceph_snap(inode) == CEPH_SNAPDIR) {
> >   		if (ceph_snap(dir) == CEPH_NOSNAP) {
> > -			strcpy(name, fsc->mount_options->snapdir_name);
> > +			strscpy(name, fsc->mount_options->snapdir_name);
> 
> This does not compile because when the size of 'name' is not known at
> compilation time, you need to use the 3-argument version of strscpy().
> 
> Please always compile test your patches before sending them. Even, when the
> change looks trivial.
> 

Sure.

> CJ
> 
> >   			err = 0;
> >   		}
> >   		goto out;
> 
> 

Should it be: NAME_MAX+1 ? 

See: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/exportfs.h?h=v6.12-rc7#n203

