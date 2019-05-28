Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE83E2C69C
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 14:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfE1MfC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 08:35:02 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:40761 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfE1MfC (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Tue, 28 May 2019 08:35:02 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Tue, 28 May 2019 14:35:00 +0200
Received: from [192.168.178.28] (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Tue, 28 May 2019 13:34:39 +0100
Subject: Re: Keynote: What's Planned for Ceph Octopus - Sage Weil -> Feedback
 on cephs Usability
To:     Owen Synge <osynge@googlemail.com>, ceph-devel@vger.kernel.org
References: <9607e2ac-ce55-60af-7b84-609783778ee2@googlemail.com>
From:   Sebastian Wagner <swagner@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=swagner@suse.com; prefer-encrypt=mutual; keydata=
 mQENBFgkpqgBCACl4ZHmEEhiZiofnuiVR3wc4ZH3ty2Y7Fgv/ttDAtyQSM3l5MrwFVEkTUKW
 zZOaLPsVl8FwBoy1ciK3cS6nOKwgYogStBBqX8mvnlb915kvhtQ84bSPQ9W5206tKfQDKmZ8
 jWjgEKCwFxH3O2teG2Jc8HFVjNWeUEdF1s9OrL6s6RQmiDf7gkzZL5ew5vS0G1yIWzJBpQzS
 GJEcjm1TmnZWN1jgkKOENBzbDQcBg/IDiLDnbSpAL4LG7RAaavMMdSyVXMOGpmbgV9vNkpTw
 0qpVttsU2t919B02bLTEbYBb3Amsfy8S+ahzQgjg2xiT94xyC7ukLQI4nKEseolN9uERABEB
 AAG0I1NlYmFzdGlhbiBXYWduZXIgPHN3YWduZXJAc3VzZS5jb20+iQE7BBMBAgAlAhsDBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCWCWwgwIZAQAKCRCNJEKAfml5+CdFB/wPI/8K94em
 Zi7GvN6FwCy0Ts+CKSYJcJoX7m0Jp6i3PaTgZMjhmH+KGH/mwXAUPE1NB/Pe/iIwrhRR9tnP
 iJgFcOh4Qe64dsk1DwftVOIk+xEBPYPb6S0FDVLdRkdJUT+2/R+yQirEQACcakHHZvbGru3e
 kF+P8OPQxX6llR3kK6MUa3RX2ZlrwiLNsw4LABKSInl0wsVlzH10LaQxujaqs/NFELR7kkZx
 wd2L3uVAmNxu2XAD6h3oEabQCN6Ol9MDPwX+QZNJ6ZTT5Qofba7Vm1zA5Tmj6mMxMK4M62qu
 5ekGxgWDRmf5Sx6PPphJ1JZY/N/TqchUlpeNIxyHGGMRuQENBFgkpqgBCAC8AHCom5ZNqJhB
 Jsftllb+TTVAtGMt/2R5c+5BfRrrd8rsN7st5hG2RECaokswFHrBWsJvxTex1V+v+ctej4SQ
 64TII9Z2ffySTzdqGFWssOUrHoJvk+4BRuJ48f+bSRETGlXILqIiAISRAfeYOJIGCbsRmijx
 fMjRPzMel2TobmCBW3YsSNVLo/3cMzF7sYHDK9IiAeb9fWrG/p5brtItlfJUmsw+1aZ42TaR
 94mcjKK0U2tTtj1fGkjhb0bRNTiXMQEWIx0xAyCaR61mGpqMhRE8FJ7eY19mAl9G5zTs604I
 ToEcJ6Bd518hJ0HXFJrqKJ/TUKL/dKR4iMViFUORABEBAAGJAR8EGAECAAkFAlgkpqgCGwwA
 CgkQjSRCgH5pefiqQwf/U+POJe0SgWBzX6+69CuRUwE68Uu0qGrNWOfWphaKPksBDx46IhhA
 UlmBJbEoo9h6E7utwwgDNf92O2Lv6yClR+2D2BA9mHLm0DBsmH04bahHGsicU1qK0rBgujqc
 GNrrgYPx3z66C7MB/o6/smS26baOChtrs5XeX3r4zE5+1yZCPb9AR8pwitNF+N81FIXE0DXp
 XhxSviD3KT4QH6Oo6f1PJ3kYnHHX9FmS/3f6hDU2o/kBwOfaP2C0ZWIcbh8VH0ENWdGl6/OK
 QJO68y6QM2NCeCAvfyISE4GERtb7/oRlvtBwWfq7OBsqLXkrKobW4sdx8Scbwb728fF14Oyn 2A==
Message-ID: <f43b54ca-6573-bb56-0165-5a76eda0f888@suse.com>
Date:   Tue, 28 May 2019 14:34:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9607e2ac-ce55-60af-7b84-609783778ee2@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="XRR7zEeeDns85o8UIUgPKzL35MdG1blpg"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XRR7zEeeDns85o8UIUgPKzL35MdG1blpg
Content-Type: multipart/mixed; boundary="T8hhTlOqM9Zn8o4XEExmpPHcraGqkLQZr";
 protected-headers="v1"
From: Sebastian Wagner <swagner@suse.com>
To: Owen Synge <osynge@googlemail.com>, ceph-devel@vger.kernel.org
Message-ID: <f43b54ca-6573-bb56-0165-5a76eda0f888@suse.com>
Subject: Re: Keynote: What's Planned for Ceph Octopus - Sage Weil -> Feedback
 on cephs Usability
References: <9607e2ac-ce55-60af-7b84-609783778ee2@googlemail.com>
In-Reply-To: <9607e2ac-ce55-60af-7b84-609783778ee2@googlemail.com>

--T8hhTlOqM9Zn8o4XEExmpPHcraGqkLQZr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hey Owen,

thanks for your detailed feedback!

Am 25.05.19 um 04:13 schrieb Owen Synge:
> Dear Ceph team,
>=20
> I have been watching Sages 5 these for octopus, and a love the themes,
> and all of Sages talk.
>=20
> Sages talk mentioned cluster usability.
>=20
> On 'the orchestrate API' slide, sage slides talk about a "Partial
> consensus to focus efforts on":
>=20
> (Option) Rook (which I don't know, but depends on Kubernetes)
>=20
> (Option) ssh (or maybe some rpc mechanism).
>=20
> I was sad not to see the option
>=20
> (Option) Support a common the most popular declarative
> puppet/chef/cfengine module.

It also depends on the amount of upstream contributions we're getting.

>=20
> I think option (ssh) exists only because work has been invested in
> complex salt and ansible implementations, but that never seem to reduce=

> in complexity. I propose we chalk it down to mistakes we made and gain
> some wisdom why option (ssh) took much more effort than expected, and
> learn from Option (Rook).>
> I think option (Rook) is a very good idea, as it works on sounds ideas =
I
> have seen work before.
>=20
> I understand that ceph should not *only* depend on anything as complex
> as Kubernetes as a deployment dependency, even if it is the best
> solution. I may not want to run some thing as complex as Kubernetes jus=
t
> to run ceph.

Yep, that's one idea behind the SSH orchestrator. We have ceph-deploy
prominently advertised in the documentation, because we don't have a
replacement for this use case yet.

>=20
> I would have liked to see on the slides:
>=20
> (Option) Look how to get Rook's benefits without Kubernetes

The reality is: Every external orchestrator (like Rook, DeepSea,
ceph-ansible) has its very own idea of how things should be defined:

Rook uses a bunch of CustomResources that define the desired state of
the cluster.

DeepSea uses the policy.cfg to define the desired start.

The SSH orchestrator uses the modules
s persistent key value store to remember a list of managed hosts.

There is simply no need to invent a new source of truth within the MGR.

Secondly, I simply don't want to maintain a function between the
orchestratemap and every external orchestrator's configuration.
Maintaining a set of state changes (orchestrator.py) is enough.

Thus, I'd stick with the source of truth we currently already have.

>=20
> I believe Rook's dependency Kubernetes, provides an architecture based
> on a declarative configuration and shared service state makes managing
> clusters easier.

Yep. Rook's CustomResources like CephCluster are a great way to maintain
the state of the cluster.

> In other words Kubernetes is like service version of
> cephs crushmap which describes how data is distributed in ceph.
>=20
> To implement (Names can be changed and are purely for illustration)
> "orchestratemapfile" -> desired deployment configfile
> =C2=A0=C2=A0=C2=A0 'orchestratemap' -> compiled with local state orches=
tratemapfile
>=20
> =C2=A0=C2=A0=C2=A0 'liborchestrate' -> shares and executes orchestratem=
ap
>=20
> So any ceph developer can understand, just like the crushmap is
> declarative and drives data, The "orchestratemap" should be declarative=

> and drive the deployment. The crushmap is shared state across the
> cluster, the orchestratemap would be a shared state across the cluster.=

> A crushmap is a compiled crushmapfile with state about the cluster. A
> orchestratemap is compiled from a orchestratemapfile with state about
> the cluster.
>=20
> Just like librados can read a crushmap and speak to a mon to get cluste=
r
> status, and drive data flow, liborchestrate

Yes, exactly! But instead of liborchestrate, we have a set of commands
defined to read and write the state of the Ceph cluster, like e.g.

ceph orchestrator service ls


> can read a orchestratemap,
> and drive the stages of ceph deployment, A MVP* would function with
> minor degradation even without shared cluster state. (ie no
> orchestratemap).

Do you have the code available? Would be great to have a look at it.
Which operations did you define? Which parameters? Which data structures?=


>=20
> A good starting point for the orchestratemapfile would be the Kubernete=
s
> config for rook, as this is essentially a desired state for the cluster=
=2E
>=20
> If you add the current state locally into the orchestratemap when
> compiling the orchestratemapfile, All desired possible operations can b=
e
> calculated by each node using just the orchestratemap and the current
> local state independently. All the operations that must be delayed due
> to dependencies in other operations can also be calculated for each
> node, this avoids, retry, timeouts, and instantly reduces error handlin=
g
> and allows for ceph to potentially, save the user from knowing that mor=
e
> than one deamon is running to provide ceph, staged upgrades,practice
> self healing at the service level, guide the users deployment with more=

> helpful error messages, and many other potential enhancements.

The Rook orchestrator is indeed much simpler, as it just needs to update
the CustomResources in Kubernetes. The rest is done by K8s and the Rook
operator (delayed operations, retries, timeouts, error handling).

>=20
> It may be argued that Option (ssh) is simpler than implementing an
> "orchestratemap" and liborchestrate that reads it, and I argue Option
> (ssh) is simpler for a test grade MVP, but for a production grade MVP
> solution I suspect implementing an "orchestratemap" and liborchestrate
> is simpler due to simpler synchronization, planning and error handling
> for management of ceph, just like the crushmap simplifies
> synchronization, planning and error handling for data in ceph.

The idea of the SSH orchestartor is to be simpler than Rook +
Kubernetes: Meaning we should not re-implement Kubernetes and Rook
within the SSH orchestrator.

>=20
> Good luck and have fun,

Thanks again for your ideas!

Best,
Sebastian

>=20
> Owen Synge
>=20
>=20
> * I once nearly finished an orchestratemapfile to ceph configuration
> once (no shared cluster state), and the bulk of the work was
> understanding how each ceph daemon interact with the cluster during
> boot, and commands to manage the demon. Only the state serialization,
> comparison and propagation where never completed.
>=20
>=20

--=20
SUSE Linux GmbH, Maxfeldstrasse 5, 90409 Nuernberg, Germany
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG N=C3=BC=
rnberg)


--T8hhTlOqM9Zn8o4XEExmpPHcraGqkLQZr--

--XRR7zEeeDns85o8UIUgPKzL35MdG1blpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEb/VfrKHiO+rLIQ4NjSRCgH5pefgFAlztKtgACgkQjSRCgH5p
efgr9QgApaV0V8jIsONYC9TPRWS7r/WnGCgpoJafvteBg04GaxnczqtdbKw9jU2j
YnqxWSJEBDsJUtEPVMTzOqcfg6DiYp5UMv+owgzIFU3E2DxRk6osUZjLJ8qxmEvP
gw18C5lZ9Y19jsSJdd6OE/9WcRlWNZrHzs2g5APSAcnDUrR52Qt/mUx/E2aFmVJc
tDIuYotUz/z8PD8Se5zryBQsozRi/daJaAzO+tDZ5nKZrJYbm7Bd9QVwe5Dwybkx
kupmgLQWgyjQuSmiKFBrUg64y7Hv4gWpwxz9pUUtIOO1om0MM/Z/+DuJFxjzT5/o
FVTZYLIEhscGLvu6hL+OCNHPzXQCqQ==
=pQGe
-----END PGP SIGNATURE-----

--XRR7zEeeDns85o8UIUgPKzL35MdG1blpg--
